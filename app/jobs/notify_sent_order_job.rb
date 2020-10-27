class NotifySentOrderJob
  include SuckerPunch::Job

  def perform(order, parcel = order.parcel)
    NotificationsMailer.with(order: order, guide: order.guide, parcel: parcel)
      .sent_order.deliver_now
  end
end
