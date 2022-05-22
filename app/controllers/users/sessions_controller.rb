class Users::SessionsController < Users::BaseController
  def login
    @user = User.find_by(mobile_number: user_params[:mobile_number])

    if @user.present?
      mobile_number = @user.mobile_number
      @code = CodeAuthenticator.generate
      @@cache.write(mobile_number, @code)
      # #######
      # Send code in SMS goes here
      # #######
      render json: { success: true, code: @code }, status: :ok
    else
      render json: { success: false, errors: 'user not found' }, status: :unprocessable_entity
    end
  end

  def validate
    binding.pry
    mobile_number = user_params[:mobile_number]
    code = user_params[:code]
    cached_code = @@cache.read(mobile_number)

    @user = User.find_by(mobile_number: mobile_number)

    if CodeAuthenticator.check(code, cached_code)
      set_headers
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    @user_params ||= params.require(:user).permit(:first_name, :last_name, :mobile_number, :code)
  end
end
