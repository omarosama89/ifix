class Providers::RegistrationsController < Providers::BaseController
  def sign_up
    @provider = Provider.new(provider_params)
    mobile_number = @provider.mobile_number
    @code = CodeAuthenticator.generate
    @@cache.write(mobile_number, @code)
    # #######
    # Send code in SMS goes here
    # #######
    if @provider.save
      render json: { success: true }, status: :created
    else
      render json: { success: false, errors: @provider.errors.messages }, status: :unprocessable_entity
    end
  end

  def validate
    mobile_number = provider_params[:mobile_number]
    code = provider_params[:code]
    other_code = @@cache.read(mobile_number)
    if CodeAuthenticator.check(code, other_code)
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
