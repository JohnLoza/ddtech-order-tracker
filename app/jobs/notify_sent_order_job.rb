class NotifySentOrderJob
  include SuckerPunch::Job

  def perform(order)
    NotificationsMailer.with(order: order, guide: order.guide)
      .sent_order.deliver_now
  end
end
