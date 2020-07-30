# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base # :nodoc:
  add_template_helper(MailerHelper)

  default from: "DD Tech <noreply@ddtech.mx>"
  default reply_to: "DD Tech <ventas@ddtech.mx>"
  layout "mailer"

  def notify_new_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def notify_supplied_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def notify_assembled_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def notify_sent_order
    @order = params[:order]
    @guide = params[:guide]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

end
