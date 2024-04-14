module Packs
  class UpdateBuyPrice < ActiveInteraction::Base
    object :pack
    boolean :update_buy_price, default: true

    def execute
      return if pack.pack_usages.empty?

      rate = CurrencyRate.last.rate
      pack_usages = pack.pack_usages
      price_in_usd = pack.price_in_usd
      # find sum of buy_prices
      price_info = []
      pack_usages.each do |pack_usage|
        price_info.push(convert_currency(rate, pack_usage, price_in_usd))
      end

      return price_info.sum unless update_buy_price

      pack.update(buy_price: price_info.sum)
    end

    private

    def convert_currency(rate, pack_usage, pack_price_in_usd)
      pack_usage_total_price = pack_usage.amount * pack_usage.list_of_pack.buy_price
      return pack_usage_total_price if pack_usage.list_of_pack.price_in_usd == pack_price_in_usd

      pack_usage_in_usd = pack_usage.list_of_pack.price_in_usd

      if pack_usage_in_usd && !pack_price_in_usd
        pack_usage_total_price * rate
      elsif !pack_usage_in_usd && pack_price_in_usd
        pack_usage_total_price / rate
      end
    end
  end
end