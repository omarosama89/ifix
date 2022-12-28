class Auth::Providers::SessionsController < DeviseTokenAuth::SessionsController
  protect_from_forgery with: :null_session

  protected

  def resource_params
    params.require(:provider).permit(:mobile_number, :password)
  end
end
