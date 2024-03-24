class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy toggle_status generate_pdf html_view]

  include Pundit::Authorization
  # GET /sales or /sales.json
  def index
    @q = Sale.includes(:buyer, :user).ransack(params[:q])
    @sales =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(created_at: :desc)

    @sales_data = @sales
    @sales = @sales.page(params[:page]).per(70)
  end

  # GET /sales/1 or /sales/1.json
  def show
    @product_sells = @sale.product_sells.includes(:buyer, :pack, :product)
    @product_sell = ProductSell.new(sale_id: @sale.id)
    @products = Product.active.order(:name)
    @rate = CurrencyRate.last.rate
    @sales = @sale.buyer.sales.where.not(id: @sale.id).order(created_at: :desc).page(params[:page]).per(7)
    @packs = Pack.includes(:product_category).where(active: true).order(:name)
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url(@sale), notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params.merge(
          status: sale_params[:status].to_i
        ))
        format.html { redirect_to html_view_sale_url(@sale) }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { redirect_to request.referrer, notice: @sale.errors.messages.values }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    return request.referrer unless params[:buyer_id].present?

    buyer = Buyer.find(params[:buyer_id])
    last_one = buyer.sales.order(created_at: :asc).last
    if !last_one.nil? && !last_one.closed?
      if last_one.product_sells.empty?
        last_one.update(created_at: DateTime.current)
      end

      redirect_to sale_url(last_one), notice: "Теперь добавьте продажу товаров"
    else
      sfs = Sale.new(buyer: buyer, user: current_user)
      if sfs.save
        redirect_to sale_url(sfs), notice: 'Теперь добавьте продажу товаров'
      else
        redirect_to request.referrer, notice: "Something went wrong"
      end
    end
  end

  def toggle_status
    authorize Sale, :manage?

    @sale.update(status: @sale.closed? ? 0 : 1)
    redirect_to request.referrer, notice: 'Successfully updated'
  end

  def generate_pdf
    authorize Sale, :access?

    pdf_generator = ProductSells::GenerateReceipt.run(sale: @sale)
    # NOTE I included mime_type.rb to receive pdf
    respond_to do |format|
      format.pdf do
        send_data(pdf_generator.result, filename: "check-#{@sale.id}-#{DateTime.current}", type: 'application/pdf', disposition: 'inline')
      end
    end
  end

  def pdf_view
    @file_path = params[:file_path]
  end

  def html_view
    rate = CurrencyRate.last.rate
    @total_debt = (@sale.buyer.calculate_debt_in_usd * rate) + @sale.buyer.calculate_debt_in_uzs
    current_total_price = @sale.total_price - @sale.total_paid
    @debt_with_exception = @total_debt - current_total_price
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.require(:sale).permit(
      :total_paid, :payment_type, :buyer_id, :total_price, :comment,
      :user_id, :status, :discount_price, :price_in_usd
    )
  end
end
