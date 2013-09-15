class ApplicationController < ActionController::Base
  protect_from_forgery
  add_crumb I18n.t("site_title"), '/'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
