# app/jobs/send_request_to_printer.rb
class SendRequestToPrinter < ApplicationJob
  queue_as :default

  def perform(sale_id)

    # Use HTTParty to send a request to the printer server
    HTTParty.post("http://localhost:4000/print/#{sale_id}",
      body: {
        id: sale_id,
        # Add any additional data needed for the print request here
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    );

    # Log or handle response if necessary
    # if response.success?
    #   Rails.logger.info("Print request successful for sale ##{sale_id}")
    # else
    #   Rails.logger.error("Print request failed for sale ##{sale_id}: #{response.body}")
    # end
  end
end
