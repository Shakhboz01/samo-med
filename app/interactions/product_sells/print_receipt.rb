require 'net/http'
require 'json'

module ProductSells
  class PrintReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      sale_data = {
        buyer: {
          name: translit(sale.buyer.name.capitalize)
        },
        id: sale.id,
        total_price: sale.total_price,
        comment: sale.comment,
        product_sells: sale.product_sells.map do |item|
          {
            sell_by_piece: item.sell_by_piece,
            product: {
              name: item.product.name.squish
            },
            pack: {
              name: item.pack.name.squish
            },
            amount: item.amount,
            sell_price: item.sell_price
          }
        end
      }

      uri = URI.parse('http://localhost:4000/print-receipt')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
      request.body = { sale: sale_data }.to_json

      response = http.request(request)

      if response.code.to_i != 200
        errors.add(:base, "Error printing receipt: #{response.message}")
      end
    rescue => exception
      errors.add(:base, "Printer connecting error")
    end
  end
end
