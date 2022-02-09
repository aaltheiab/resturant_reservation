class TablesController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin
  before_action :find_table, only: %i[update destroy]

  # GET /tables
  def index
    render json: Table.all, status: :ok
  end

  # POST /tables
  def create
    table = Table.new(table_params)
    if table.save
      render json: table, status: :created
    else
      render json: { errors: table.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /tables/{id}
  def update
    unless @table.update(table_params)
      return render json: { errors: @table.errors.full_messages }, status: :unprocessable_entity
    end

    render json: @table, status: :no_content
  end

  # DELETE /tables/{id}
  def destroy
    return render_error('Cannot delete a table that has a reservation/s to it') if @table.reservations.exists?
    @table.destroy
  end

  private

    def find_table
      @table = Table.find_by_id!(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Table not found' }, status: :not_found
    end

    def table_params
      params.permit(:number, :number_of_seats)
    end
end
