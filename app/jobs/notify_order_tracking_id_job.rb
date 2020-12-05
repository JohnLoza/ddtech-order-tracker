class NotifyOrderTrackingIdJob
  include SuckerPunch::Job

  def perform(order, parcel = order.parcel)
    OrderMailer.with(order: order, guide: order.guide, parcel: parcel)
      .tracking_id.deliver_now
  end
end
