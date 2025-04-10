class MembersController < ApplicationController
  include SetTenant
  include RequireTenant

  before_action :set_member, only: %i[ show edit update destroy ]
  before_action :set_current_member
  before_action :require_admin, only: %i[ invite edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.includes(:user, :tenant).all
  end

  def invite
    email = params[:email]
    user_from_email = User.where(email: email).first

    if email.present?
      if user_from_email.present?
        if Member.where(user: user_from_email).any?
          redirect_to members_path, alert: "The organization #{current_tenant.name} already has a user with the email #{email}"
        else
          new_member = Member.create!(user: user_from_email)
          MemberMailer.invited(new_member).deliver_now
          redirect_to members_path, notice: "#{email} was invited to join the organization #{current_tenant.name}"
        end
      elsif user_from_email.nil?
        new_user = User.invite!({ email: email }, current_user)
        if new_user.persisted?
          Member.create!(user: new_user)
          redirect_to members_path, notice: "#{email} was invited to join the organization #{current_tenant.id}"
        else
          redirect_to members_path, alert: "Something went wrong. Plase tray again"
        end
      end
    else
      redirect_to members_path, alert: "No email provided!"
    end
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
      params.require(:member).permit(*Member::ROLES)
    end

    def require_admin
      return if @current_member&.admin?
    
      redirect_to members_path, alert: "You are not authorized"
    end
    
    def set_current_member
      @current_member ||= Member.find_by(user: current_user)
    end
end
