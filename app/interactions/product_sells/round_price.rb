module ProductSells
  class RoundPrice < ActiveInteraction::Base
    decimal :number

    def execute
      rounded_number = number.round(-3)  # Round to the nearest thousand
      last_three_digits = rounded_number % 1000

      if last_three_digits >= 500
        rounded_number += (1000 - last_three_digits)
      else
        rounded_number -= last_three_digits
      end

      rounded_number
    end
  end
end
