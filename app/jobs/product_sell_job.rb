# app/jobs/product_sell_job.rb
class ProductSellJob < ApplicationJob
  queue_as :default

  def perform(product_sell_id, action)
    product_sell = ProductSell.find(product_sell_id)
    send(action.to_sym, product_sell)
  end

  private

  def perform_sell(product_sell)
    pack = product_sell.pack
    sell_amount = product_sell.amount

    ActiveRecord::Base.transaction do
      total_buy_price = 0
      total_sell_price = 0
      total_profit = 0
      usd_to_uzs_rate = CurrencyRate.last.rate

      product_entries = ProductEntry.where(pack_id: pack.id).order(created_at: :asc)
      remaining_amount = sell_amount

      product_entries.each do |entry|
        break if remaining_amount <= 0

        available_amount = entry.amount - entry.amount_sold
        amount_to_sell = [available_amount, remaining_amount].min

        buy_price = entry.buy_price
        sell_price = product_sell.price_in_usd ? product_sell.sell_price : product_sell.sell_price / usd_to_uzs_rate.to_f

        total_buy_price += buy_price * amount_to_sell
        total_sell_price += sell_price * amount_to_sell
        total_profit += (sell_price - buy_price) * amount_to_sell

        entry.update!(amount_sold: entry.amount_sold + amount_to_sell)
        remaining_amount -= amount_to_sell
      end

      if remaining_amount > 0
        last_entry = product_entries.last || create_placeholder_entry(pack.id, product_sell)
        buy_price = last_entry.buy_price
        sell_price = product_sell.price_in_usd ? product_sell.sell_price : product_sell.sell_price / usd_to_uzs_rate

        total_buy_price += buy_price * remaining_amount
        total_sell_price += sell_price * remaining_amount
        total_profit += (sell_price - buy_price) * remaining_amount

        last_entry.update!(amount_sold: last_entry.amount_sold + remaining_amount)
      end

      product_sell.update!(
        buy_price: total_buy_price / sell_amount,
        sell_price: total_sell_price / sell_amount,
        total_profit: total_profit
      )

    end
  rescue => e
    # Handle exceptions, possibly logging the error or notifying
    puts "Error: #{e.message}"
  end

  def handle_update(product_sell)
    if product_sell.price_in_usd_changed?
      handle_deletion(product_sell)
      perform_sell(product_sell)
    end
  end

  def handle_deletion(product_sell)
    pack = product_sell.pack
    usd_to_uzs_rate = CurrencyRate.last.rate

    ActiveRecord::Base.transaction do
      remaining_amount = product_sell.amount

      product_entries = ProductEntry.where(pack_id: pack.id).order(created_at: :desc)

      product_entries.each do |entry|
        break if remaining_amount <= 0

        amount_to_revert = [entry.amount_sold, remaining_amount].min

        entry.update!(amount_sold: entry.amount_sold - amount_to_revert)
        remaining_amount -= amount_to_revert
      end

    end
  rescue => e
    # Handle exceptions, possibly logging the error or notifying
    puts "Error: #{e.message}"
  end

  def create_placeholder_entry(pack_id, product_sell)
    # Create a placeholder entry with buy_price and sell_price as per pack or product_sell
    ProductEntry.create!(
      pack_id: pack_id,
      buy_price: pack.buy_price,
      sell_price: pack.sell_price,
      amount: 0,
      amount_sold: 0,
      paid_in_usd: pack.price_in_usd
    )
  end
end
