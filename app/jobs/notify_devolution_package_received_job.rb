class NotifyDevolutionPackageReceivedJob
  include SuckerPunch::Job

  def perform(devolution)
    return if Rails.env.test?
    DevolutionMailer.with(devolution: devolution)
      .package_received.deliver_now
  end
end
