class Providers::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  @@cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 3.minutes)

  def current_provider
    @current_provider ||= Provider.find_by(id: request.headers['ifix-uid'])
  end

  def authenticate_provider!
    mobile_number = request.headers['ifix-mobile-number']
    token = request.headers['ifix-token']
    if current_provider.mobile_number != mobile_number && current_provider.token != token
      render json: { success: false, message: 'unquthorized' }, status: 401
    end
  end

  private

  def set_headers
    response.set_header('ifix-uid', @provider.id)
    response.set_header('ifix-mobile-number', @provider.mobile_number)
    response.set_header('ifix-token', @provider.token)
    response.set_header('ifix-reset-token', @provider.reset_token)
  end
end
