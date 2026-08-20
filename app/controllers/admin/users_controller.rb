module Admin
  class UsersController < ApplicationController
    def index
      authorize User
      @users = User.all
    end

    def new
      authorize User
      @user = User.new
    end

    def create
      authorize User
      # Invites user and sends email verification link
      @user = User.invite!(user_params, current_user)
      if @user.persisted?
        redirect_to admin_users_path, notice: "Invitation email sent to #{@user.email}."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :role, :billing_day, :profile_photo)
    end
  end
end