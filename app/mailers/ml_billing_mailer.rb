# frozen_string_literal: true

class MlBillingMailer < ApplicationMailer # :nodoc:
  default reply_to: "DD Tech <facturacion@ddtech.mx>"

  def billing
    @ml_billing = params[:ml_billing]

    recipient = Rails.env.production? ? 'facturacion@ddtech.mx' : 'ventas7@ddtech.mx'
    subject = "Solicita Factura ML #{@ml_billing[:pseudonym]} | #{l(Time.now, format: :long)}"

    mail(to: recipient, subject: subject)
  end
end

