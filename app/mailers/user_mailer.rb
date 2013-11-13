class UserMailer < ActionMailer::Base
  default from: "winecrawler@163.com"

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

  def user_monitor(user_monitor)
    @user = user_monitor.user
    @user_monitor = user_monitor
    @wine_monitor = user_monitor.wine_monitor
    mail to: user.email,
      :subject => "「酒比价监视器」#{@wine_monitor.name}当前价格已经低于您设置的监视价格，还不来看看？"
  end
end
