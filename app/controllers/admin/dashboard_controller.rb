# frozen_string_literal: true

module Admin
  # Admin Dashboard Controller
  class DashboardController < AdminController
    skip_authorization_check

    def index; end
  end
end
