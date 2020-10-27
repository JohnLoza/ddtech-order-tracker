# frozen_string_literal: true

class NotificationsMailer < ActionMailer::Base # :nodoc:
  add_template_helper(MailerHelper)

  default from: "DD Tech <noreply@ddtech.mx>"
  default reply_to: "DD Tech <ventas@ddtech.mx>"
  layout "notifications_mailer"

  def start_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def supplied_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def assembled_order
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def sent_order
    @order = params[:order]
    @guide = params[:guide]
    @order.parcel = params[:parcel] if params[:parcel].present?

    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end
end
