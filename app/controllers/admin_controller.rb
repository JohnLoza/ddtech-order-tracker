# frozen_string_literal: true

# Base Admin controller
class AdminController < ApplicationController
  layout 'admin'
  before_action :require_active_session

  private

  def require_active_session
    return if logged_in?

    store_location
    redirect_to new_session_path
  end

  def deny_access
    respond_to do |format|
      format.html { redirect_to admin_dashboard_index_path, flash: { info: 'Acceso Denegado' } }
      format.any { head :forbidden, content_type: 'text/html' }
    end
    true
  end
end
