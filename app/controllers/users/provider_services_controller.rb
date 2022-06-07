class Users::ProviderServicesController < Users::BaseController
  MAX_DISTANCE = 40
  before_action :authenticate_user!

  def index
    max_distance = params[:max_distance].nil? ? MAX_DISTANCE : params[:max_distance].to_i
    provider_services = ProviderService.includes(:provider)
       .where(service_id: provider_service_params[:service_ids].split(','))
    point = Point.new(lat: provider_service_params[:lat].to_f, lng: provider_service_params[:lng].to_f)
    @provider_services = FilterProviderServicesByDistance.run!(
      point: point, provider_services: provider_services, max_distance: max_distance
    )
  end

  private

  def provider_service_params
    params.permit(:service_ids, :lat, :lng, :max_distance)
  end
end
