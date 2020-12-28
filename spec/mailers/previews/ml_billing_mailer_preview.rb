# frozen_string_literal: true

class MlBillingMailerPreview < ActionMailer::Preview # :nodoc:

  def billing
    ml_billing = {
      pseudonym: 'seudonimo',
      ml_folio: '28934ukls',
      email: 'some@mail.com',
      name: 'sample name',
      rfc: 'lobe941009hv9',
      cfdi: 'gastos en general',
      payment_method: 'some payment method',
      street: 'sample street',
      ext_number: '238',
      int_number: '',
      colony: 'sample colony',
      zc: '28342',
      city: 'sample city',
      state: 'sample state'
    }
    MlBillingMailer.with(ml_billing: ml_billing).billing
  end
end

