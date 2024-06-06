# app/services/product_sells/print_receipt.rb

require 'socket'
escpos_image_path = $LOAD_PATH.find { |p| p =~ /escpos-image/ }
$LOAD_PATH.delete(escpos_image_path)
require 'escpos'
$LOAD_PATH.insert($LOAD_PATH.index { |p| p =~ /escpos/ }, escpos_image_path)
require 'escpos/image'

module ProductSells
  class PrintReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      Rails.logger.info("Starting print receipt process for sale ID: #{sale.id}")

      # Prepare the receipt content
      basic_format = "%-10s %-10s %-10s\n"
      printer = Escpos::Printer.new
      printer << basic_format % ["\n\ Mijoz: #{translit sale.buyer.name.capitalize}", strf_datetime(DateTime.current), sale.id]
      printer << Escpos::Helpers.center(Escpos::Helpers.big(Escpos::Helpers.bold("\nMED\n\n")))
      printer << "-----------------------------------------------\n"

      sale.product_sells.each_with_index do |item, index|
        total_price = item.amount * item.sell_price
        printer << "#{index + 1}. #{translit(item.sell_by_piece ? item.product.name.squish : item.pack.name.squish)}\n"
        printer << Escpos::Helpers.right("#{item.amount} * #{num_to_usd item.sell_price} = #{num_to_usd total_price}\n")
      end

      printer << "-----------------------------------------------\n"
      printer << Escpos::Helpers.left(Escpos::Helpers.bold(translit "Jami: #{num_to_usd(sale.total_price)}\n"))
      printer << Escpos::Helpers.left(Escpos::Helpers.bold(translit "#{sale.comment}\n"))
      printer << "-----------------------------------------------\n\n"
      printer << Escpos::Helpers.center("970000000\n")
      printer << Escpos::Helpers.center("Address: Andijon\n\n\n\n\n\n\n\n\n")

      begin
        ip = PrinterIp.last.ip
        port = 9100

        Rails.logger.info("Connecting to printer at #{ip}:#{port}")
        socket = TCPSocket.new "192.168.0.98", port

        printer.cut!
        socket.write printer.to_escpos
        socket.close

        Rails.logger.info("Receipt printed successfully for sale ID: #{sale.id}")

      rescue SocketError => e
        Rails.logger.error("SocketError: #{e.message}")
        errors.add(:base, "Printer connection error: #{e.message}")
      rescue StandardError => e
        Rails.logger.error("StandardError: #{e.message}")
        errors.add(:base, "An error occurred: #{e.message}")
      end
    end
  end
end
