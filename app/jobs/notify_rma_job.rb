class NotifyRmaJob
  include SuckerPunch::Job

  def perform(devolution)
    DevolutionMailer.with(devolution: devolution)
      .rma.deliver_now
  end
end
