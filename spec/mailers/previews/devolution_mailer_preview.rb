# frozen_string_literal: true

# http://localhost:3000/rails/mailers/devolution_mailer/method_name
class DevolutionMailerPreview < ActionMailer::Preview # :nodoc:

  def rma
    DevolutionMailer.with(devolution: Devolution.first).rma
  end

  def package_received
    DevolutionMailer.with(devolution: Devolution.first).package_received
  end

  def tracking_id
   DevolutionMailer.with(devolution: Devolution.first).tracking_id
  end

end

