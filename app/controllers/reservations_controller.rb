class ReservationsController < ApplicationController

  before_action :authorize_request

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
