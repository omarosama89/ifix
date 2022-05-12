class Providers::SessionsController < Providers::BaseController
  def login
    @provider = Provider.find_by(mobile_number: provider_params[:mobile_number])

    if @provider.present?
      mobile_number = @provider.mobile_number
      @code = CodeAuthenticator.generate
      @@cache.write(mobile_number, @code)
      # #######
      # Send code in SMS goes here
      # #######
      render json: { success: true }, status: :ok
    else
      render json: { success: false, errors: 'provider not found' }, status: :unprocessable_entity
    end
  end

  def validate
    mobile_number = provider_params[:mobile_number]
    code = provider_params[:code]
    cached_code = @@cache.read(mobile_number)
    if CodeAuthenticator.check(code, cached_code)
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  private

  def provider_params
    @provider_params ||= params.require(:provider).permit(:first_name, :last_name, :mobile_number, :code)
  end
end
