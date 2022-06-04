class Users::ProviderServicesController < Users::BaseController
  MAX_DISTANCE = 40
  before_action :authenticate_user!

  def index
    @provider_services = ProviderService.includes(:provider).where(service_id: provider_service_params[:service_ids])
  end

  private

  def provider_service_params
    params.require(:provider_service).permit(:service_ids, :lat, :lng, :max_distance)
  end
end
