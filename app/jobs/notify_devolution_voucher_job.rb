class NotifyDevolutionVoucherJob
  include SuckerPunch::Job

  def perform(devolution)
    return if Rails.env.test?
    DevolutionMailer.with(devolution: devolution)
      .voucher.deliver_now
  end
end
