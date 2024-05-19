require 'telegram/bot'

Thread.new do
  token = '6319741438:AAFOj3A4Gob0hCFWowtBJfaL14d8DbAZaxc'
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
            kb = [
              [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Xaridorlarni qidirish', callback_data: 'buyers'),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Tovarlarni qidirish', callback_data: 'packs')
              ]
            ]
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
            bot.api.send_message(chat_id: id, text: 'Tanlang', reply_markup: markup)
          else
            # If user has a context, process their search input
            case user.context
            when 'buyers'
              buyers = Buyer.where('LOWER(name) LIKE ?', "%#{message.text.downcase}%")
              if buyers.any?
                buyers.each do |buyer|
                  bot.api.send_message(chat_id: id, text: "Mijoz: #{buyer.name}, Telefon: #{buyer.phone_number}, Qarzi: #{buyer.calculate_debt_in_usd}$ | #{buyer.calculate_debt_in_uzs}", reply_markup: start_keyboard)
                end
              else
                bot.api.send_message(chat_id: id, text: "Topilmadi.", reply_markup: start_keyboard)
              end
            when 'packs'
              packs = Pack.active.where('LOWER(name) LIKE ?', "%#{message.text.downcase}%")
              if packs.any?
                packs.each do |pack|
                  bot.api.send_message(chat_id: id, text: "Tovar: #{pack.name}, Kod: #{pack.code}, Narx: #{pack.sell_price}, Ostatka: #{pack.initial_remaining}", reply_markup: start_keyboard)
                end
              else
                bot.api.send_message(chat_id: id, text: "Topilmadi.", reply_markup: start_keyboard)
              end
            else
              bot.api.send_message(chat_id: id, text: 'Mavjud emas', reply_markup: start_keyboard)
            end
          end
        when Telegram::Bot::Types::CallbackQuery
          case message.data
          when 'buyers'
            bot.api.send_message(chat_id: message.message.chat.id, text: "Mijoz ismini kiriting:", reply_markup: start_keyboard)
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
