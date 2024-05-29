module ProductSells
  class HandleDelete < ActiveInteraction::Base
    integer :id

    def execute
      product_sell = ProductSell.find(id)
      pack = product_sell.pack
      usd_to_uzs_rate = CurrencyRate.last.rate
      remaining_amount = product_sell.amount
      product_entries = ProductEntry.where(pack_id: pack.id).order(created_at: :desc)
      product_entries.each do |entry|
        break if remaining_amount <= 0

        amount_to_revert = [entry.amount_sold, remaining_amount].min
        entry.update(amount_sold: entry.amount_sold - amount_to_revert)
        remaining_amount -= amount_to_revert
      end
    end
  end
end
