class Users::RegistrationsController < Users::BaseController
  def sign_up
    @user = User.new(user_params)
    mobile_number = @user.mobile_number
    @code = CodeAuthenticator.generate
    @@cache.write(mobile_number, @code)
    # #######
    # Send code in SMS goes here
    # #######
    if @user.save
      render json: { success: true }, status: :created
    else
      render json: { success: false, errors: @user.errors.messages }, status: :unprocessable_entity
    end
  end

  def validate
    mobile_number = user_params[:mobile_number]
    code = user_params[:code]
    other_code = @@cache.read(mobile_number)
    if CodeAuthenticator.check(code, other_code)
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
