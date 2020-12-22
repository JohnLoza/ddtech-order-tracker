# frozen_string_literal: true

module Admin
  # Admin Users Controller
  class UsersController < AdminController
    before_action :load_users, only: :index
    load_and_authorize_resource

    def index; end

    def show; end

    def new; end

    def create
      if @user.save
        redirect_to [:admin, @user], flash: { success: t('.success', user: @user) }
      else
        render :new
      end
    end

    def edit
      @user.email_confirmation = @user.email
    end

    def update
      if @user.update user_params
        redirect_to [:admin, @user], flash: { success: t('.success', user: @user) }
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        flash[:success] = t('.success', user: @user, url: restore_admin_user_path(@user))
      else
        flash[:info] = t('.failure', user: @user)
      end
      redirect_to admin_users_path
    end

    def restore
      if @user.restore!
        flash[:success] = t('.success', user: @user)
        redirect_to [:admin, @user]
      else
        flash[:info] = t('.failure', user: @user)
        redirect_to admin_users_path
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :email_confirmation,
        :role,
        :password,
        :password_confirmation
      )
    end

    def load_users
      @pagy, @users = pagy(
        User.active.not(current_user).order_by_name
          .search(keywords: filter_params(require: :keywords), fields: [:name, :email])
          .by_role(filter_params(require: :role))
      )
    end
  end
end
