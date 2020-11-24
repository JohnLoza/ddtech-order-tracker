# frozen_string_literal: true

# Controller for managing user sessions
class SessionsController < ApplicationController
  layout false

  def new
    redirect_to admin_dashboard_index_path and return if logged_in?
  end

  def create
    user = authenticate_user(params[:session])
    if user
      log_in(user, params[:session][:remember_me])
      redirect_back_or admin_dashboard_index_path
    else
      flash.now[:info] = 'El correo y/o contraseña es incorrecto'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
