class ProcessReceiptJob < ApplicationJob
  queue_as :default

  def perform(sale)
    ProductSells::PrintReceipt.run(sale: sale)
  end
end
