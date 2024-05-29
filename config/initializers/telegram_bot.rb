if Rails.env.production?
require 'telegram/bot'

Thread.new do
  token = ENV.fetch('TELEGRAM_TOKEN', nil)
  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      id = message.from.id

      user = User.find_by(telegram_chat_id: id)
      bot.logger.info('Bot has been started')

      # Define the persistent keyboard
      start_keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [[{ text: '/start' }]],
        resize_keyboard: true,
        one_time_keyboard: false
      )

      if user.nil?
        case message.text
        when '/start'
          bot.api.send_message(chat_id: id, text: "Avval tizimga kiring va qayta urinib ko'ring: #{ENV['APP_HOST_URL']}/users/sign_in?telegram_chat_id=#{id}", reply_markup: start_keyboard)
        else
          bot.api.send_message(chat_id: id, text: "Please authorize first.", reply_markup: start_keyboard)
        end
      else
        case message
        when Telegram::Bot::Types::Message
          case message.text
          when '/start'
            Rails.logger.warn '---------------------------'
            Rails.logger.warn "message is: #{message}"

          else
            # If user has a context, process their search input
            case user.context
            when 'buyers'
              sale = Sale.find_by(id: message.text)
              buyer = sale.buyer
              if buyer
                user.update(context: 'comment', buyer_context: buyer.id)
                bot.api.send_message(chat_id: id, text: buyer.name.capitalize, reply_markup: start_keyboard)
                treatments = buyer.treatments.order(id: :desc)
                tr_message = ''
                treatments.each do |tr|
                  tr_message << "#{tr.comment}. Sana: #{tr.created_at.strftime("%Y-%m-%d %H:%M")}. Врач: #{tr.user.name}\n"
                end

                bot.api.send_message(chat_id: id, text: "#{tr_message}\n Yangi tashxis kiriting:", reply_markup: start_keyboard)
              else
                bot.api.send_message(chat_id: id, text: 'Mijoz topilmadi. ID ni qayta kiriting:', reply_markup: start_keyboard)
              end
            when 'comment'
              Treatment.create(comment: message.text, user_id: user.id, buyer_id: user.buyer_context)
              bot.api.send_message(chat_id: id, text: 'Izoh qo‘shildi', reply_markup: start_keyboard)
              user.update(context: 'buyers', buyer_context: nil)
            else
              bot.api.send_message(chat_id: id, text: 'Mavjud emas, qaytatdan urinib ko\'ring', reply_markup: start_keyboard)
              user.update(context: 'buyers', buyer_context: nil)
            end
          end
        when Telegram::Bot::Types::CallbackQuery
          case message.data
          when 'buyers'
            bot.api.send_message(chat_id: message.message.chat.id, text: "Mijoz ID ni kiriting:", reply_markup: start_keyboard)
            user.update(context: 'buyers')
          when 'packs'
            bot.api.send_message(chat_id: message.message.chat.id, text: "Tovar nomini kiriting:", reply_markup: start_keyboard)
            user.update(context: 'packs')
          end
        end
      end
    end
  end
end
end
