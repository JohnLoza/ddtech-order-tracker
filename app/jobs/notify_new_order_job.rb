class NotifyNewOrderJob
  include SuckerPunch::Job

  def perform(order)
    OrderMailer.with(order: order)
      .new.deliver_now
  end
end
