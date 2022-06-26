class Users::RequestsController < Users::BaseController
  before_action :authenticate_user!

  def create
    price = GetRequestPrice.run!(
      provider_service_ids: request_params.require(:request_details_attributes)
        .map { |req_detail| req_detail[:provider_service_id]}
    )
    request = Request.new(request_params.merge({
      price: price,
      user_id: current_user.id,
      status: Request::STATUSES[:pending]
    }))

    if request.save
      render json: { success: true }, status: 201
    else
      render json: { success: false, errors: request.errors.messages }
    end
  end

  private

  def request_params
    params.require(:request).permit(:lat, :lng, request_details_attributes: [:id, :request_id, :provider_service_id])
  end
end
