class NotifyOrderSuppliedJob
  include SuckerPunch::Job

  def perform(order)
    OrderMailer.with(order: order)
      .supplied.deliver_now
  end
end
