class NotifyDevolutionTrackingIdJob
  include SuckerPunch::Job

  def perform(devolution)
    return if Rails.env.test?
    DevolutionMailer.with(devolution: devolution)
      .tracking_id.deliver_now
  end
end
