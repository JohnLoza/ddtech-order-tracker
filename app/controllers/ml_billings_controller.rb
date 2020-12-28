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
      :ml_folio,
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
