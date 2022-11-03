class MlBillingsController < ApplicationController
  layout false

  def new
  end

  def create
    @ml_billing = ml_billing_params
    NotifyMlBillingDataJob.perform_async(@ml_billing)
  end

  private
  def ml_billing_params
    params.require(:ml_billing).permit(
      :pseudonym,
      :person_type,
      :fiscal_regimen,
      :email,
      :name,
      :rfc,
      :cfdi,
      :payment_type,
      :street,
      :ext_number,
      :int_number,
      :colony,
      :zc,
      :city,
      :state
    )
  end
end
