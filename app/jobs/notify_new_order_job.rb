class NotifyNewOrderJob
  include SuckerPunch::Job

  def perform(order)
    return if Rails.env.test?
    OrderMailer.with(order: order)
      .new.deliver_now
  end
end
