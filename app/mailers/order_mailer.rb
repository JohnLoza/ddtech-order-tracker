# frozen_string_literal: true

class OrderMailer < ActionMailer::Base # :nodoc:
  add_template_helper(MailerHelper)

  default from: "DD Tech <noreply@ddtech.mx>"
  default reply_to: "DD Tech <ventas@ddtech.mx>"
  layout "mailer"

  def new
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def supplied
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def assembled
    @order = params[:order]
    subject = t('mailer.subjects.order_status',
      key: @order.ddtech_key, datetime: l(Time.now, format: :long))

    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

  def tracking_id
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