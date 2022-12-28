class Auth::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery with: :null_session

  protected

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :password, :password_confirmation)
  end
end
