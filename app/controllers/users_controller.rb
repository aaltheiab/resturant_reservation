class UsersController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params.merge({ role: User::ROLE_EMPLOYEE }))
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

    def find_user
      @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
      params.permit(
        :name, :employee_number, :password, :password_confirmation
      )
    end
end
