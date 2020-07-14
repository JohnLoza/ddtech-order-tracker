# frozen_string_literal: true

# Utilities for session purposes
module SessionsHelper
  def authenticate_user(options = {})
    if options[:auth_token].nil? && (options[:email].nil? || options[:password].nil?)
      raise ArgumentError, 'an :email and :password are required or an :auth_token'
    end

    if options[:auth_token].present?
      decoded_token = JsonWebToken.decode(options[:auth_token])
      user = User.find_by(id: decoded_token[:user_id]) if decoded_token
      return nil unless user
    else
      user = User.find_by(email: options[:email])
      return nil unless user&.authenticate(options[:password])
    end

    user.active? ? user : nil
  end

  def log_in(user, remember_me = '0')
    session[:user_id] = user.id
    remember(user) unless remember_me.to_i.zero?
  end

  def remember(user)
    token = JsonWebToken.encode(user_id: user.id)
    cookies.permanent[:auth_token] = token
  end

  def current_user?(user)
    user.id == current_user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (auth_token = cookies[:auth_token])
      user = authenticate_user(auth_token: auth_token)
      if user
        log_in user
        @current_user = user
      else
        forget_current_user
        nil
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def forget_current_user
    cookies.delete(:auth_token)
  end

  def log_out
    return unless logged_in?

    forget_current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
