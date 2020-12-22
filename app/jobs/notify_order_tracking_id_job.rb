class NotifyOrderTrackingIdJob
  include SuckerPunch::Job

  def perform(order, parcel = order.parcel)
    return if Rails.env.test?
    OrderMailer.with(order: order, guide: order.guide, parcel: parcel)
      .tracking_id.deliver_now
  end
end
