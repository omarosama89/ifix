class Users::ProviderServicesController < Users::BaseController
  before_action :authenticate_user!

  def index
    @services = Service.includes(:provider_services).where.not(provider_services: { id: nil }).distinct
  end
end
