class NotifyRmaJob
  include SuckerPunch::Job

  def perform(devolution)
    return if Rails.env.test?
    DevolutionMailer.with(devolution: devolution)
      .rma.deliver_now
  end
end
