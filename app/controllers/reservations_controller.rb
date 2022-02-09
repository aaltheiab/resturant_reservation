class ReservationsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin, except: [:today, :availability, :destroy, :create]
  before_action :set_reservation, only: [:destroy]

  # GET /reservations
  def index
    reservations = Reservation.filter(params.slice(:table_number, :from_date, :to_date)).paginate(page: params[:page], per_page: 10)
    render_json(reservations, count: reservations.total_entries)
  end

  # POST /reservations
  def create
    table = Table.find_by_number(params[:table_number])
    return render_error('Invalid Table Number') unless table

    start_time = parse_time(params[:start_at])
    end_time = parse_time(params[:end_at])

    return render_error('Start/End time must be in this format hh:mm') unless start_time && end_time

    reservation = Reservation.new(reservation_params.merge({ table: table, start_at: start_time, end_at: end_time }))
    if reservation.save
      render_json(reservation, status: :created)
    else
      render_error(reservation.errors.full_messages)
    end
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

    # TODO fix best match to handle responding with time slots
    tables = Table.best_match(required_seats)
    render json: tables, status: :ok
  end

  private

    def parse_time(time)
      # assuming time will be passed with hh:mm (e.g. 16:45 which is 4:45 PM)
      Time.zone.now.change(hour: time.split(':')[0], minute: time.split(':')[1]) rescue nil
    end

    def set_reservation
      @reservation = Reservation.find_by_id!(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Reservation not found' }, status: :not_found
    end

    def reservation_params
      params.permit(:seats, :customer_name)
    end

end
