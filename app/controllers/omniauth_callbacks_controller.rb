# OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      flash[:alert] = 'Login error, try again'
      redirect_to new_user_session_path
    end
  end

  def twitter
    store_to_session
    user = User.find_for_oauth(request.env['omniauth.auth'])

    render('oauth/email_input') && return unless user

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
  end

  def send_confirmation_email
    session[:email] = params[:email]
    user = User.find_for_oauth(session, true)
    user.send_confirmation_instructions

    render 'oauth/send_confirmational_email'
  end

  private

  def store_to_session
    session[:uid] = request.env['omniauth.auth'].uid
    session[:provider] = request.env['omniauth.auth'].provider
  end
end
