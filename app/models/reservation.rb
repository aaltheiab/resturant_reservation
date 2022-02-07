class Reservation < ApplicationRecord
  include Filterable
  MIN_NUMBER_OF_SEATS = 1
  MAX_NUMBER_OF_SEATS = 12

  OPENS_AT = "12 PM"
  CLOSES_AT = "11:59 PM"

  belongs_to :table

  validates :start_at, :end_at, :customer_name, :seats, presence: true
  validates :seats, presence: true, inclusion: { in: MIN_NUMBER_OF_SEATS..MAX_NUMBER_OF_SEATS,
                                                 message: 'Must Be Within 1 to 12' }
  validate :validate_start_end_at, if: -> { start_at and end_at }
  scope :today, -> { where(["start_at between ? and ?", "#{Time.zone.now}", "#{Time.zone.now.end_of_day}"]) }
  scope :filter_by_table_number, -> (table_number) { joins(:table).where(table: {number: table_number}) }
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
      errors.add(:start_at, "can't be after end at") if start_at > end_at
      errors.add(:start_at, "must be within working hours #{OPENS_AT} and #{CLOSES_AT}") unless start_at.to_s(:time).between?('12:00', '23:59')
      errors.add(:end_at, "must be within working hours #{OPENS_AT} and #{CLOSES_AT}") unless end_at.to_s(:time).between?('12:00', '23:59')
    end
end
