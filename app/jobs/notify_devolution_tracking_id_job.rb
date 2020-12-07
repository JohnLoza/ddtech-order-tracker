class NotifyDevolutionTrackingIdJob
  include SuckerPunch::Job

  def perform(devolution)
    DevolutionMailer.with(devolution: devolution)
      .tracking_id.deliver_now
  end
end
