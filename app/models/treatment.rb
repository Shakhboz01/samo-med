class Treatment < ApplicationRecord
  belongs_to :buyer
  belongs_to :user
  before_create :send_message

  private

  def send_message
    return if (sales = buyer.sales).empty?

    message =
      "<b><a href=\"https://#{ENV.fetch('HOST_URL')}/sales/#{sales.last.id}\">TASHXIS</a>\n" \
      "Bemor: #{buyer.name}\n" \
      "Vrach: #{user.name}\n" \
      "#{comment}"
      SendMessageJob.perform_later(message)
  end
end
