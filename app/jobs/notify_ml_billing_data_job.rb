class NotifyMlBillingDataJob
  include SuckerPunch::Job

  def perform(ml_billing)
    return if Rails.env.test?
    MlBillingMailer.with(ml_billing: ml_billing)
      .billing.deliver_now
  end
end
