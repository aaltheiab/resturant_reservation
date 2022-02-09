class Reservation < ApplicationRecord
  include Filterable
  MIN_NUMBER_OF_SEATS = 1
  MAX_NUMBER_OF_SEATS = 12
  ALLOWED_MINUTES = [0, 15, 30, 45]
  MIN_HOUR_IN_24 = 12
  MAX_HOUR_IN_24 = 23

  OPENS_AT = "12 PM"
  CLOSES_AT = "11:59 PM"

  belongs_to :table

  validates :start_at, :end_at, :customer_name, presence: true
  validates :seats, presence: true, inclusion: { in: MIN_NUMBER_OF_SEATS..MAX_NUMBER_OF_SEATS,
                                                 message: 'Must Be Within 1 to 12' }
  validate :validate_start_end_at, if: -> { start_at and end_at }
  validate :overlap_time_slots, if: -> { start_at and end_at }
  scope :today, -> { where(["start_at between ? and ?", "#{Time.zone.now}", "#{Time.zone.now.end_of_day}"]) }
  scope :filter_by_table_number, -> (table_number) { joins(:table).where(table: { number: table_number }) }
  scope :filter_by_from_date, -> (date) { where(['start_at >= ?', "#{date}"]) }
  scope :filter_by_to_date, -> (date) { where(['start_at <= ?', "#{date}"]) }

  def self.valid_seats?(seats)
    seats = Integer(seats) rescue nil
    return unless seats
    seats.between?(MIN_NUMBER_OF_SEATS, MAX_NUMBER_OF_SEATS)
  end

  def self.invalid_seats_msg
    "Invalid Number of Seats. Must be Integer between #{MIN_NUMBER_OF_SEATS} and #{MAX_NUMBER_OF_SEATS} inclusive"
  end

  def can_be_deleted?
    return false unless start_at.today? # immediate reject if reservation isn't within today

    # definitely within today & still not started
    return true if start_at >= Time.now

    false # we passed start_at then it cannot be deleted
  end

  private

    def validate_start_end_at
      now = Time.zone.now
      errors.add(:base,
        "You can only make reservations during the rest of the today"
      ) and return if start_at < now  || start_at > now.end_of_day

      errors.add(:base, "Reservation start time cannot be after end time") if start_at > end_at

      hour = start_at.hour
      unless hour.between?(MIN_HOUR_IN_24, MAX_HOUR_IN_24)
        errors.add(:start_at, "must be within working hours #{OPENS_AT} and #{CLOSES_AT} in 24 hours format YYYY-MM-DD hh:mm")
        return
      end

      start_minute = Integer(start_at.strftime('%M'))
      unless ALLOWED_MINUTES.include?(start_minute)
        errors.add(:start_at, "must be within every quarter of an hour")
        return
      end

      hour = end_at.hour
      unless hour.between?(MIN_HOUR_IN_24, MAX_HOUR_IN_24)
        errors.add(:end_at, "must be within working hours #{OPENS_AT} and #{CLOSES_AT} in 24 hours format YYYY-MM-DD hh:mm")
        return
      end

      end_minute = Integer(end_at.strftime('%M'))
      unless ALLOWED_MINUTES.include?(end_minute)
        errors.add(:end_at, "must be within every quarter of an hour")
      end
    end

    def overlap_time_slots
      return false if errors.present?

      if table.has_available_slot?(start_at, end_at)
        true
      else
        errors.add(:base, "There is no available slot for the selected time")
      end
    end
end
