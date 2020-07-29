# frozen_string_literal: true

# Base Admin controller
class AdminController < ApplicationController
  include Pagy::Backend
  include AdminHelper

  layout 'admin'
  before_action :require_active_session

  check_authorization
  skip_authorization_check only: :render_404

  rescue_from CanCan::AccessDenied do |_exception|
    deny_access
  end

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
