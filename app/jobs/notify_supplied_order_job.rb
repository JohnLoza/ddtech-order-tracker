class NotifySuppliedOrderJob
  include SuckerPunch::Job

  def perform(order)
    NotificationsMailer.with(order: order)
      .supplied_order.deliver_now
  end
end
