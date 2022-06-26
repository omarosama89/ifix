class Providers::RequestsController < Providers::BaseController
  before_action :authenticate_provider!

  def accept
    if request_object.update(status: Request::STATUSES[:accepted])
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: request_object.errors.messages }, status: 400
    end
  end

  def process_request
    if request_object.update(status: Request::STATUSES[:processing])
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: request_object.errors.messages }, status: 400
    end
  end

  def complete
    if request_object.update(status: Request::STATUSES[:completed])
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: request_object.errors.messages }, status: 400
    end
  end

  private

  def request_object
    @request_object ||= Request.find(params[:id])
  end
end
