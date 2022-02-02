class AuthController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by(employee_number: params[:employee_number])

    if @user&.authenticate(params[:password])
      token = Jwt.encode(employee_number: @user.employee_number)
      render json: { token: token, exp: 24.hours.from_now.strftime("%Y-%m-%d %H:%M %p") }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

    def login_params
      params.permit(:employee_number, :password)
    end
end
