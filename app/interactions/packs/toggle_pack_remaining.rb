module Packs
  class TogglePackRemaining < ActiveInteraction::Base
    symbol :action
    object :pack
    decimal :amount

    def execute
      return if pack.pack_usages.empty?

      pack.pack_usages.each do |pack_usage|
        amount_to_toggle = pack_usage.amount * amount
        case action
        when :increment
          pack_usage.list_of_pack.increment!(:initial_remaining, amount_to_toggle)
        when :decrement
          pack_usage.list_of_pack.decrement!(:initial_remaining, amount_to_toggle)
        else
          Rails.logger.warn 'Unhandled action'
        end
      end
    end
  end
end