# frozen_string_literal: true

# Controller for managing user sessions
class SessionsController < AdminController
  skip_before_action :require_active_session
  skip_authorization_check

  def new
    redirect_to admin_dashboard_index_path and return if logged_in?

    render :new, layout: false
  end

  def create
    user = authenticate_user(params[:session])
    if user
      log_in(user, params[:session][:remember_me])
      redirect_back_or admin_dashboard_index_path
    else
      flash.now[:info] = 'El correo y/o contraseña es incorrecto'
      render :new, layout: false
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
