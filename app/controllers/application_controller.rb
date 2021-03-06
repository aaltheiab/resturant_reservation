class ApplicationController < ActionController::Base

  # disable forgery checks due to the application is being used as APIs
  protect_from_forgery with: :null_session

  def render_json(payload, status: :ok, count: nil)
    response = { data: payload }

    response[:count] = count if count

    render json: response, status: status
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def render_error(msg, status = :bad_request)
    render json: { error: msg }, status: status
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = Jwt.decode(header)
      @current_user = User.find_by_employee_number(@decoded[:employee_number])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_admin
    unless @current_user and @current_user.admin?
      render json: {}, status: :unauthorized
    end
  end

end
