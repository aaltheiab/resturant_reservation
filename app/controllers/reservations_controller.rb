class ReservationsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin, except: [:today, :availability, :destroy]
  before_action :set_reservation, only: [:destroy]

  # GET /reservations
  def index
    reservations = Reservation.filter(params.slice(:table_number, :from_date, :to_date)).paginate(page: params[:page], per_page: 10)
    render_json(reservations, count: reservations.total_entries)
  end

  # DELETE /reservations/
  def destroy
    if @reservation.can_be_deleted?
      @reservation.destroy
      render json: {}
    else
      render_error('Cannot Delete Past Reservations')
    end
  end

  # GET /reservations/today
  def today
    reservations = Reservation.today.paginate(page: params[:page], per_page: 10)
    render_json(reservations, count: reservations.total_entries)
  end

  # GET /reservations/availability
  def availability
    required_seats = reservation_params[:seats]
    return render_error(Reservation.invalid_seats_msg) unless Reservation.valid_seats?(required_seats)

    tables = Table.best_match(required_seats)
    render json: tables, status: :ok
  end

  private

    def set_reservation
      @reservation = Reservation.find_by_id!(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Reservation not found' }, status: :not_found
    end

    def reservation_params
      params.permit(:seats, :table_number)
    end

end
