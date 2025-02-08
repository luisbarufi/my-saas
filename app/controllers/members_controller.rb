class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.all
  end

  def invite
    email = params[:email]
    user = User.find_by(email: email)
  
    if user && Member.exists?(user: user)
      redirect_to members_path, alert: "The organization #{current_tenant.name} already has a user with the email #{email}"
      return
    end
  
    user ||= User.invite!({ email: email }, current_user)
    Member.create!(user: user)
  
    redirect_to members_path, notice: "#{email} was invited to join the organization #{current_tenant.name}"
  end
  

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/1/edit
  def edit
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_path, status: :see_other, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:user_id)
    end
end
