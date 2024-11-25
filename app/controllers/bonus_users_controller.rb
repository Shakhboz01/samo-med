class BonusUsersController < ApplicationController
  before_action :set_bonus_user, only: %i[ show edit update destroy ]

  # GET /bonus_users or /bonus_users.json
  def index
    @bonus_users = BonusUser.all
  end

  # GET /bonus_users/1 or /bonus_users/1.json
  def show
  end

  # GET /bonus_users/new
  def new
    @bonus_user = BonusUser.new
  end

  # GET /bonus_users/1/edit
  def edit
  end

  # POST /bonus_users or /bonus_users.json
  def create
    @bonus_user = BonusUser.new(bonus_user_params)

    respond_to do |format|
      if @bonus_user.save
        format.html { redirect_to bonus_users_url, notice: "Bonus user was successfully created." }
        format.json { render :show, status: :created, location: @bonus_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bonus_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bonus_users/1 or /bonus_users/1.json
  def update
    respond_to do |format|
      if @bonus_user.update(bonus_user_params)
        format.html { redirect_to bonus_users_url, notice: "Bonus user was successfully updated." }
        format.json { render :show, status: :ok, location: @bonus_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bonus_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bonus_users/1 or /bonus_users/1.json
  def destroy
    @bonus_user.destroy

    respond_to do |format|
      format.html { redirect_to bonus_users_url, notice: "Bonus user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bonus_user
      @bonus_user = BonusUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bonus_user_params
      params.require(:bonus_user).permit(:name)
    end
end
