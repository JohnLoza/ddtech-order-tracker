module MailerHelper
  def mailer_image_tag(image, options = {})
    attachments.inline[image] = File.read(Rails.root.join("public/images/#{image}"))
    image_tag attachments[image].url, options
  end
end
