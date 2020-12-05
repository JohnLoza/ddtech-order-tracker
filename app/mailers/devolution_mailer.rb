# frozen_string_literal: true

class DevolutionMailer < ActionMailer::Base # :nodoc:
  add_template_helper(MailerHelper)

  default from: "DD Tech <noreply@ddtech.mx>"
  default reply_to: "DD Tech <soporte@ddtech.mx>"
  layout "mailer"

  def rma
    @devolution = params[:devolution]
    subject = "Soporte DD TECH #{@devolution.rma}"

    mail(to: @devolution.email, subject: subject)
  end
end

