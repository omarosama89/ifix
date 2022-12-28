class Users::ServicesController < ApiApplicationController
  before_action :authenticate_auth_user!

  def index
    @services = Service.includes(:provider_services).where.not(provider_services: { id: nil }).distinct
  end
end
