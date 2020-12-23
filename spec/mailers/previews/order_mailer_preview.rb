# frozen_string_literal: true

# http://localhost:3000/rails/mailers/order_mailer/method_name
class OrderMailerPreview < ActionMailer::Preview # :nodoc:

  def new
    OrderMailer.with(order: Order.first).new
  end

  def supplied
    OrderMailer.with(order: Order.first).supplied
  end

  def assembled
    OrderMailer.with(order: Order.first).assembled
  end

  def tracking_id
    OrderMailer.with(order: Order.first, guide: 1234567890).tracking_id
  end
end
