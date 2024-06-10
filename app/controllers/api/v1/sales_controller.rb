module Api
  module V1
    class SalesController < Api1Controller
      skip_before_action :verify_authenticity_token

      def show
        @sale = Sale.find(params[:id])
        @product_sells = @sale.product_sells
      end
    end
  end
end
