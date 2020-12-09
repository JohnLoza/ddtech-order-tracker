class NotifyDevolutionPackageReceivedJob
  include SuckerPunch::Job

  def perform(devolution)
    DevolutionMailer.with(devolution: devolution)
      .package_received.deliver_now
  end
end
