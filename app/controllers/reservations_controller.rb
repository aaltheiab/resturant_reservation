class ReservationsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin, except: [:today, :availability]

  # GET /reservations
  def index
    reservations = Reservation.paginate(page: params[:page], per_page: 10)
    render_json(reservations, count: reservations.total_entries)
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

    def reservation_params
      params.permit(:seats)
    end

end
