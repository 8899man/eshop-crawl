class UserMailer < ActionMailer::Base
  default from: "levichengood@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.cheap.subject
  #
  def cheap(email, wine)
    @wine = wine
    #@greeting = "Hi"
    #@message = "Thank you for confirmation!"
    mail to: email, :subject => "#{@wine}降价至#{@wine.current_price},可以入手了，还不来看看？"
  end
end
