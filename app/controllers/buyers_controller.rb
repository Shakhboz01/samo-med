class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[ toggle_active show edit update destroy toggle_active ]

  # GET /buyers or /buyers.json
  def index
    @q = Buyer.ransack(params[:q])
    @buyers = @q.result.order(active: :desc).page(params[:pahe]).per(70)
  end

  # GET /buyers/1 or /buyers/1.json
  def show
    @treatment = Treatment.new(buyer_id: @buyer.id)
    @treatments = @buyer.treatments.order(id: :desc)
    @sales = @buyer.sales
  end

  # GET /buyers/new
  def new
    @buyer = Buyer.new
  end

  # GET /buyers/1/edit
  def edit
  end

  # POST /buyers or /buyers.json
  def create
    @buyer = Buyer.new(buyer_params)

    respond_to do |format|
      if @buyer.save
        last_one = @buyer.sales.order(created_at: :asc).last
        if !last_one.nil? && !last_one.closed?
          if last_one.product_sells.empty?
            last_one.update(created_at: DateTime.current)
          end

          format.html { redirect_to sale_url(last_one), notice: "Теперь добавьте продажу товаров" }
        else
          sfs = Sale.new(buyer: @buyer, user: current_user, price_in_usd: ENV.fetch('PRICE_IN_USD'))
          if sfs.save
            format.html { redirect_to sale_url(sfs), notice: 'Теперь добавьте продажу товаров' }
          else
            format.html { redirect_to request.referrer, notice: "Something went wrong" }
          end
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @buyer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buyers/1 or /buyers/1.json
  def update
    respond_to do |format|
      if @buyer.update(buyer_params)
        format.html { redirect_to buyers_url, notice: "Buyer was successfully updated." }
        format.json { render :show, status: :ok, location: @buyer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @buyer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buyers/1 or /buyers/1.json
  def destroy
    @buyer.destroy

    respond_to do |format|
      format.html { redirect_to buyers_url, notice: "Buyer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @buyer.toggle(:active).save
    redirect_to request.referrer || buyers_path, notice: "Successfully updated"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_buyer
    @buyer = Buyer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def buyer_params
    params.require(:buyer).permit(:name, :phone_number, :comment, :active, :debt_in_uzs, :debt_in_usd, :image, :is_worker)
  end
end
