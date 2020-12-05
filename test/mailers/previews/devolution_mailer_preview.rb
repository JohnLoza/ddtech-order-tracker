# frozen_string_literal: true

# http://localhost:3000/rails/mailers/devolution_mailer/method_name
class DevolutionMailerPreview < ActionMailer::Preview # :nodoc:

  def rma
    DevolutionMailer.with(devolution: Devolution.first).rma
  end

end

