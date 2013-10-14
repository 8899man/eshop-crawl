class AuthenticationsController < Devise::OmniauthCallbacksController
  def baidu
    omniauth_baidu_process
  end

  protected
  def omniauth_process
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first

    if authentication
      set_flash_message(:notice, :signed_in)
      sign_in(:user, authentication.user)
      remember_me(authentication.user)
      redirect_to root_path
    elsif current_user
      authentication = Authentication.create_from_hash(current_user.id, omniauth)
      set_flash_message(:notice, :add_provider_success)
      redirect_to user_authentications_path
    else
      session[:omniauth] = omniauth.except("extra")
      set_flash_message(:notice, :fill_your_info)
      redirect_to new_user_registration_url
    end
  end

  def omniauth_baidu_process
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.where(provider: omniauth.info.media_type, uid: omniauth.info.media_uid).first

    if authentication
      set_flash_message(:notice, :signed_in)
      sign_in(:user, authentication.user)
      authentication.user.remember_me!
      redirect_to root_path
    elsif current_user
      authentication = Authentication.create_from_hash(current_user.id, omniauth)
      set_flash_message(:notice, :add_provider_success)
      redirect_to authentications_path
    else
      session[:omniauth] = omniauth.except("extra")
      set_flash_message(:notice, :fill_your_info)
      redirect_to new_user_registration_url
    end
  end

end
