class PackUsagesController < ApplicationController
  before_action :set_pack_usage, only: %i[ show edit update destroy ]

  # GET /pack_usages or /pack_usages.json
  def index
    @pack_usages = PackUsage.all
  end

  # GET /pack_usages/1 or /pack_usages/1.json
  def show
  end

  # GET /pack_usages/new
  def new
    @pack_usage = PackUsage.new
  end

  # GET /pack_usages/1/edit
  def edit
  end

  # POST /pack_usages or /pack_usages.json
  def create
    @pack_usage = PackUsage.new(pack_usage_params)

    respond_to do |format|
      if @pack_usage.save
        format.html { redirect_to pack_usage_url(@pack_usage), notice: "Pack usage was successfully created." }
        format.json { render :show, status: :created, location: @pack_usage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pack_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pack_usages/1 or /pack_usages/1.json
  def update
    respond_to do |format|
      if @pack_usage.update(pack_usage_params)
        format.html { redirect_to pack_usage_url(@pack_usage), notice: "Pack usage was successfully updated." }
        format.json { render :show, status: :ok, location: @pack_usage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pack_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pack_usages/1 or /pack_usages/1.json
  def destroy
    @pack_usage.destroy

    respond_to do |format|
      format.html { redirect_to pack_usages_url, notice: "Pack usage was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pack_usage
      @pack_usage = PackUsage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pack_usage_params
      params.require(:pack_usage).permit(:pack_id, :amount)
    end
end
