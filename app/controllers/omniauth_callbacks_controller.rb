# OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def twitter
    @uid = request.env['omniauth.auth'].uid
    @provider = request.env['omniauth.auth'].provider

    authorization = Authorization.where(uid: @uid, provider: @provider).first
    if authorization
      @user = authorization.user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      render 'oauth/email_input'
    end
  end

  def send_confirmation_email
    user = User.find_for_oauth(params, true)
    user.send_confirmation_instructions

    render 'oauth/send_confirmational_email'
  end
end
