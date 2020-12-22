class NotifyOrderAssembledJob
  include SuckerPunch::Job

  def perform(order)
    return if Rails.env.test?
    OrderMailer.with(order: order)
      .assembled.deliver_now
  end
end
