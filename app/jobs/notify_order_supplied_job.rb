class NotifyOrderSuppliedJob
  include SuckerPunch::Job

  def perform(order)
    return if Rails.env.test?
    OrderMailer.with(order: order)
      .supplied.deliver_now
  end
end
