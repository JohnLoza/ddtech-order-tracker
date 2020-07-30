class NotifyAssembledOrderJob
  include SuckerPunch::Job

  def perform(order)
    NotificationsMailer.with(order: order)
      .assembled_order.deliver_now
  end
end
