# frozen_string_literal: true

# This is the base application controller
class ApplicationController < ActionController::Base
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound do |_e|
    render_404
  end

  rescue_from ActionController::UnknownFormat do |_e|
    render_404
  end

  rescue_from ActionController::InvalidAuthenticityToken do |_e|
    render_404
  end

  rescue_from ActionController::ParameterMissing do |e|
    render_parameter_validation_error(e.message)
  end

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('public', '404'), layout: false, status: 404 }
      format.any { head :not_found, content_type: 'text/html' }
    end
    true
  end

  private
  def render_parameter_validation_error(msg)
    response = { status: :error, message: 'parameter_validation_error', details: msg }
    render status: 422, json: JSON.pretty_generate(response)
    true
  end
end
