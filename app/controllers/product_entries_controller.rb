class ProductEntriesController < ApplicationController
  include Pundit::Authorization
  before_action :set_product_entry, only: %i[ show edit update destroy ]

  # GET /product_entries or /product_entries.json
  def index
    @q = ProductEntry.ransack(params[:q])
    @product_entries = @q.result.includes(:pack, :user).order(created_at: :desc)
    @product_entries_data = @product_entries
    @product_entries = @product_entries.page(params[:page]).per(70)
  end

  # GET /product_entries/1 or /product_entries/1.json
  def show
  end

  # GET /product_entries/new
  def new
    return redirect_to define_product_destination_product_entries_path if params[:local_entry].nil?

    @product_entry = ProductEntry.new(
      return: params[:return],
      delivery_from_counterparty_id: params[:delivery_from_counterparty_id],
    )
    @products = Product.active
  end

  def define_product_destination; end

  # GET /product_entries/1/edit
  def edit
  end

  # POST /product_entries or /product_entries.json
  def create
    @product_entry = ProductEntry.new(product_entry_params)

    respond_to do |format|
      if @product_entry.save
        format.html { redirect_to request.referrer || product_entries_url, notice: "Product entry was successfully created." }
        format.json { render :show, status: :created, location: @product_entry }
      else
        format.html { redirect_to request.referrer, notice: @product_entry.errors.messages }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_entries/1 or /product_entries/1.json
  def update
    authorize ProductEntry, :manage?

    respond_to do |format|
      if @product_entry.update(product_entry_params)
        if @product_entry.delivery_from_counterparty_id.present?
          format.html { redirect_to delivery_from_counterparty_url(@product_entry.delivery_from_counterparty), notice: "Product entry was successfully updated." }
        end

        format.html { redirect_to product_entries_url, notice: "Product entry was successfully updated." }
        format.json { render :show, status: :ok, location: @product_entry }
      else
        format.html { redirect_to request.referrer, notice: @product_entry.errors.messages }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_entries/1 or /product_entries/1.json
  def destroy
    @product_entry.destroy

    respond_to do |format|
      if @product_entry.delivery_from_counterparty_id.present?
        format.html { redirect_to delivery_from_counterparty_url(@product_entry.delivery_from_counterparty), notice: "Product entry was successfully destroyed." }
      end

      format.html { redirect_to product_entries_url, notice: "Product entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_entry
    @product_entry = ProductEntry.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_entry_params
    params.require(:product_entry).permit(:local_entry, :product_code, :product_category, :buy_price, :sell_price, :user_id, :price_in_percentage, :delivery_from_counterparty_id, :pack_id, :storage_id, :service_price, :provider_id, :amount, :amount_sold, :total_paid, :total_price, :comment, :return)
  end
end
