class UsersController < ApplicationController
  before_action :set_user, only: %i[ show resend_invitation ]

  def index
    @users = User.all
  end

  def resend_invitation
    if @user.invitation_accepted_at.present?
      redirect_to members_path, alert: "User with email #{@user.email} has already accepted the invitation"
    else
      @user.invite!
      redirect_to members_path, notice: "Invitation resent to #{@user.email}"
    end
  end

  def show
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
