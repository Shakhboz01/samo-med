class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[ show edit update destroy ]

  # GET /treatments or /treatments.json
  def index
    @q = Treatment.ransack(params[:q])
    @treatments = @q.result.includes(:buyer, :user)
    @total_treatments = Treatment.count

    @bosh_ogriq_count = @treatments.where(bosh_ogriq: true).count
    @qon_bosimi_kotarilishi_count = @treatments.where(qon_bosimi_kotarilishi: true).count
    @holsizlik_count = @treatments.where(holsizlik: true).count
    @bel_va_oyoq_ogriqi_count = @treatments.where(bel_va_oyoq_ogriqi: true).count
    @gejga_tolishi_count = @treatments.where(gejga_tolishi: true).count
    @teri_kasalliklari_count = @treatments.where(teri_kasalliklari: true).count
    @koz_kasalliklari_count = @treatments.where(koz_kasalliklari: true).count
    @jkt_kasalliklari_count = @treatments.where(jkt_kasalliklari: true).count
    @boshqa_shikoyatlar_count = @treatments.where(boshqa_shikoyatlar: true).count

    @tish_gijirlashi_count = @treatments.where(tish_gijirlashi: true).count
    @jirrakilik_count = @treatments.where(jirrakilik: true).count
    @orqa_qichishishi_count = @treatments.where(orqa_qichishishi: true).count
    @toshma_va_doglar_count = @treatments.where(toshma_va_doglar: true).count
    @ishtaxasizlik_count = @treatments.where(ishtaxasizlik: true).count
    @boy_osmaslik_count = @treatments.where(boy_osmaslik: true).count
    @oyoq_ogrigi_count = @treatments.where(oyoq_ogrigi: true).count
    @siyib_qoyish_count = @treatments.where(siyib_qoyish: true).count

    @treatments = @treatments.page(params[:page]).per(40)
  end

  # GET /treatments/1 or /treatments/1.json
  def show
  end

  # GET /treatments/new
  def new
    @treatment = Treatment.new
  end

  # GET /treatments/1/edit
  def edit
  end

  # POST /treatments or /treatments.json
  def create
    @treatment = Treatment.new(treatment_params)
    @treatment.user_id = current_user.id
    respond_to do |format|
      if @treatment.save
        format.html { redirect_to request.referrer, notice: "Treatment was successfully created." }
        format.json { render :show, status: :created, location: @treatment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @treatment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /treatments/1 or /treatments/1.json
  def update
    respond_to do |format|
      if @treatment.update(treatment_params)
        format.html { redirect_to treatment_url(@treatment), notice: "Treatment was successfully updated." }
        format.json { render :show, status: :ok, location: @treatment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @treatment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /treatments/1 or /treatments/1.json
  def destroy
    @treatment.destroy

    respond_to do |format|
      format.html { redirect_to treatments_url, notice: "Treatment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_treatment
      @treatment = Treatment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def treatment_params
      params.require(:treatment).permit(
        :buyer_id, :user_id, :comment,
        :bosh_ogriq, :qon_bosimi_kotarilishi, :holsizlik, :bel_va_oyoq_ogriqi,
        :gejga_tolishi, :teri_kasalliklari, :koz_kasalliklari, :jkt_kasalliklari,
        :boshqa_shikoyatlar, :tish_gijirlashi, :jirrakilik, :orqa_qichishishi,
        :toshma_va_doglar, :ishtaxasizlik, :holsizlik, :boy_osmaslik, :oyoq_ogrigi, :siyib_qoyish
      )
    end
end
