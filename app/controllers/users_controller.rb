class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role == 1
      @users = User.all
    else
      redirect_to user_path(current_user)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def update_role
    @user = User.find(params[:id])
    if @user.update(role_params)
      redirect_to users_path, notice: 'Role updated successfully'
    else
      redirect_to users_path, alert: 'Failed to update role'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation)
  end

  def role_params
    params.require(:user).permit(:role)
  end

  def password_confirmation_matches
    if params[:user][:password].present? && params[:user][:password_confirmation].present?
      if params[:user][:password] != params[:user][:password_confirmation]
        # add an error to the @user object
        @user.errors.add(:password_confirmation, "must match password")
      end
    end
  end
end
