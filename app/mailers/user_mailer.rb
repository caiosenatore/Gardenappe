class UserMailer < ApplicationMailer
  default from: "no-reply@gardenappe.com.br"

  def email_authentication user, email_auth_url
    @user = user
    @url = email_auth_url
    mail(to: @user.email, subject: 'Welcome to Gardenappe, we need to check your e-mail!')
  end
end