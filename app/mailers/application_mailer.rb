# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base # :nodoc:
  add_template_helper(MailerHelper)

  default from: "DD Tech <noreply@ddtech.mx>"
  default reply_to: "DD Tech <ventas@ddtech.mx>"
  layout "mailer"

  def notify_order_status_change
    @order = params[:order]
    subject = t('mailer.subjects.order_status_changed', key: @order.ddtech_key)
    subject += " | #{l(Time.now, format: :long)}"
    mail(
      to: @order.client_email,
      reply_to: @order.user.email,
      subject: subject)
  end

end
