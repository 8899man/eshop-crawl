class Users::SessionsController < Devise::SessionsController

  add_crumb(I18n.t("controller.sessions"))
end

