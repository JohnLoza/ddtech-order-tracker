class ApplicationMailer < ActionMailer::Base
  add_template_helper(MailerHelper)

  default from: "DD Tech <noresponder@discosdurosymas.net>"
  layout "mailer"
end

