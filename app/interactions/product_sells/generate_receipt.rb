module ProductSells
  class GenerateReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      rate = CurrencyRate.last.rate
      # calculating debt in uzs
      total_debt = (sale.buyer.calculate_debt_in_usd * rate) + sale.buyer.calculate_debt_in_uzs
      current_total_price = sale.price_in_usd ? ((sale.total_price - sale.total_paid) * rate) : sale.total_price
      debt_with_exception = total_debt - current_total_price
      items = [
        ["<b></b>", "<b></b>", "<b>Mijozning qarzdorligi:</b>", "<b>#{num_to_usd(debt_with_exception)}</b>"],
        ['', '', '', ''],
        ["<b>Товар</b>", "<b>Количество</b>", "<b>Цена</b>", "<b>Итого цена</b>"]
      ]
      sale.product_sells.each do |product_sell|
        items.push(
          [
            product_sell.pack.name,
            product_sell.amount,
            currency_convert(product_sell.price_in_usd, product_sell.sell_price),
            currency_convert(product_sell.price_in_usd, product_sell.sell_price * product_sell.amount)
          ]
        )
      end

      items.push(
        ['', '', '', ''],
        [
        '<b>Итого:</b>',
        '',
        '',
        currency_convert(sale.price_in_usd, sale.total_price)
      ])
      items.push([
        '<b>Итого оплачено:</b>', '', '', currency_convert(sale.price_in_usd, sale.total_paid)
      ])
      items.push([
        '', '', "<b>Xariddan keyingi qarzdorlik holati:</b>", "#{num_to_usd(total_debt)}"
      ])
      r = Receipts::Receipt.new(
        title: 'AUTEX',
        font: {
          bold: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          italic: File.expand_path("./app/assets/fonts/CharisSILB.ttf"),
          normal: File.expand_path("./app/assets/fonts/Alice-Regular.ttf")
        },
        details: [
          ["Номер чека:", sale.id],
          ["Дата:", sale.created_at.strftime("%D - %H:%M")],
          ['Исполнитель:', sale.user.name],
          ["Тип оплаты:", sale.payment_type]
        ],
        company: {
          name: "ООО 'PARTS-LINE AUTO'",
          address: "Чупон Ота дом 171",
          phone: '+998915257779',
          email: "parts.line1@mail.ru",
          logo: File.expand_path("./app/assets/images/logo2.png")
        },
        recipient: [
          "<b>Покупатель</b>: #{sale.buyer.name}"
        ],
        line_items: items,
        footer: "Спасибо за покупку, ждём вас снова."
      )

      r.render
      downloads_directory = File.join(Dir.home, "Downloads")
      filename = "чек-#{sale.id}-#{DateTime.current.to_i}.pdf"
      file_path = File.join(downloads_directory, filename)
      r.render_file(file_path)
      { filename: filename, file_path: file_path }
    end
  end
end
