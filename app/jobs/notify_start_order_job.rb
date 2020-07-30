class NotifyStartOrderJob
  include SuckerPunch::Job

  def perform(order)
    NotificationsMailer.with(order: order)
      .start_order.deliver_now
  end
end
