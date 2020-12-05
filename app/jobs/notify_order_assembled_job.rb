class NotifyOrderAssembledJob
  include SuckerPunch::Job

  def perform(order)
    OrderMailer.with(order: order)
      .assembled.deliver_now
  end
end
