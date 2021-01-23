# frozen_string_literal: true

module Admin
  # Admin Dashboard Controller
  class GuidesController < AdminController
    skip_authorization_check

    def index
      start_date = filter_params(require: :start_date)
      end_date = filter_params(require: :end_date)

      @pagy, @guides = pagy(
        Movement.sent.search(
            keywords: filter_params(require: :keywords),
            fields: [:data])
          .by_user(filter_params(require: :user_id))
          .by_parcel(filter_params(require: :parcel))
          .between_dates(start_date, end_date)
          .recent.includes(:order, :user)
      )
    end

  end
end
