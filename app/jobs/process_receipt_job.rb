class ProcessReceiptJob < ApplicationJob
  queue_as :default

  def perform(sale, user_ip)
    ProductSells::PrintReceipt.run(sale: sale, user_ip: user_ip)
  end
end
