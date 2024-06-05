require 'socket'
escpos_image_path = $LOAD_PATH.find { |p| p =~ /escpos-image/ }
$LOAD_PATH.delete(escpos_image_path)
# require the base escpos gem, which requires its own escpos/helpers
require 'escpos'
# re-add and require the escpos-image gem to Ruby's LOAD_PATH
$LOAD_PATH.insert($LOAD_PATH.index {|p| p =~ /escpos/}, escpos_image_path)
require 'escpos/image'

module ProductSells
  class PrintReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      # image_path = Rails.root.join('app', 'assets', 'images', 'logo.png')
      # image = Escpos::Image.new image_path, {
      #   processor: "ChunkyPng",
      #   extent:  true
      # }
      basic_format = "%-10s %-10s %-10s\n"
      printer = Escpos::Printer.new
      printer << basic_format % ["\n\ Mijoz: #{translit sale.buyer.name.capitalize}", strf_datetime(DateTime.current), sale.id]
      # printer << Escpos::Helpers.center(image.to_escpos)
      printer << Escpos::Helpers.center(Escpos::Helpers.big(Escpos::Helpers.bold("\n#{ENV.fetch('COMPANY_NAME')}\n\n")))
      printer << "-----------------------------------------------\n"
      sale.product_sells.each_with_index do |item, index|
        total_price = item.amount * item.sell_price
        body_format = "%-20s %-20s\n"
        printer << "#{index + 1}. #{translit(item.sell_by_piece ? item.product.name.squish : item.pack.name.squish)}\n"
        printer << Escpos::Helpers.right("#{item.amount} * #{num_to_usd item.sell_price} = #{num_to_usd total_price}\n")
      end
      printer << "-----------------------------------------------\n"
      printer << "-----------------------------------------------\n"
      printer << Escpos::Helpers.left(Escpos::Helpers.bold(translit "Jami: #{num_to_usd(sale.total_price)}\n"))
      printer << Escpos::Helpers.left(Escpos::Helpers.bold(translit "#{sale.comment}\n"))
      printer << "-----------------------------------------------\n\n"
      printer << Escpos::Helpers.center("#{ENV.fetch('COMPANY_PHONE_NUMBER')}\n")
      printer << Escpos::Helpers.center("Address: #{ENV.fetch('COMPANY_ADDRESS')}\n\n\n\n\n\n\n\n\n")

      begin
        ip = PrinterIp.last.ip
        socket = TCPSocket.new ip, ENV.fetch('PRINTER_PORT')
      rescue => exception
        return errors.add(:base, "Printer connecting error")
      end

      printer.cut!
      socket.write printer.to_escpos
      socket.close
    end
  end
end
