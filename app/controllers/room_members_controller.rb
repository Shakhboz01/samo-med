class RoomMembersController < ApplicationController
  before_action :set_room_member, only: %i[ show edit update destroy ]

  # GET /room_members or /room_members.json
  def index
    @q = RoomMember.includes(:buyer, :room).ransack(params[:q])
    @room_members = @q.result.page(params[:pahe]).per(60)
  end

  # GET /room_members/1 or /room_members/1.json
  def show
  end

  # GET /room_members/new
  def new
    @room_member = RoomMember.new(
      buyer_id: params[:buyer_id], room_id: params[:room_id]
    )
  end

  # GET /room_members/1/edit
  def edit
  end

  # POST /room_members or /room_members.json
  def create
    @room_member = RoomMember.new(room_member_params)

    respond_to do |format|
      if @room_member.save
        format.html { redirect_to room_url(@room_member.room), notice: "Room member was successfully created." }
        format.json { render :show, status: :created, location: @room_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_members/1 or /room_members/1.json
  def update
    respond_to do |format|
      if @room_member.update(room_member_params)
        format.html { redirect_to room_url(@room_member.room), notice: "Room member was successfully updated." }
        format.json { render :show, status: :ok, location: @room_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_members/1 or /room_members/1.json
  def destroy
    @room_member.destroy

    respond_to do |format|
      format.html { redirect_to room_members_url, notice: "Room member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_member
      @room_member = RoomMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_member_params
      params.require(:room_member).permit(:active_member, :comment, :buyer_id, :end_time, :room_id)
    end
end
