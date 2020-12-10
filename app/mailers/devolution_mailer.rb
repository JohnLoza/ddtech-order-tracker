# frozen_string_literal: true

class DevolutionMailer < ApplicationMailer # :nodoc:
  default reply_to: "DD Tech <soporte@ddtech.mx>"

  def rma
    @devolution = params[:devolution]
    subject = subject_for @devolution

    mail(to: @devolution.email, subject: subject)
  end

  def package_received
    @devolution = params[:devolution]
    @user = @devolution.user
    subject = subject_for @devolution

    mail(to: @devolution.email, reply_to: @user.email, subject: subject)
  end

  def tracking_id
    @devolution = params[:devolution]
    subject = subject_for @devolution

    mail(to: @devolution.email, subject: subject)
  end

  private
  def subject_for(devolution)
    return "Soporte DD TECH #{@devolution.rma} | #{l(Time.now, format: :long)}"
  end
end

