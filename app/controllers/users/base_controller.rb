class Users::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  @@cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 3.minutes)

  def current_user
    @current_user ||= User.find_by(id: request.headers['ifix-uid'])
  end

  # def authenticate_user!
  #   mobile_number = request.headers['ifix-mobile-number']
  #   token = request.headers['ifix-token']
  #   binding.pry
  #   unless current_user&.mobile_number == mobile_number && current_user&.token == token
  #     render json: { success: false, errors: 'unauthorized' }, status: 401
  #   end
  # end

  private

  def set_headers
    response.set_header('ifix-uid', @user.id)
    response.set_header('ifix-mobile-number', @user.mobile_number)
    response.set_header('ifix-token', @user.token)
    response.set_header('ifix-reset-token', @user.reset_token)
  end
end
