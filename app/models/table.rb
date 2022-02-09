class Table < ApplicationRecord
  MIN_NUMBER_OF_SEATS = 1
  MAX_NUMBER_OF_SEATS = 12

  has_many :reservations

  validates :number_of_seats, presence: true, inclusion: { in: MIN_NUMBER_OF_SEATS..MAX_NUMBER_OF_SEATS,
                                                           message: 'Must Be Within 1 to 12' }
  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :number, uniqueness: true

  def self.best_match(seats)
    tables = best_table(seats)
    return [] unless tables

    best_time_slots(tables)
  end

  def self.best_time_slots(tables)
    result = []
    tables.each do |table|

      now = Time.zone.now
      start_time = now > now.noon ? now : now.noon # set to 12 noon if we are currently in the morning

      if table.has_reservations_today?
        # TODO calculate rest of the day excluding today's reservations
        rvs = table.reservations.order('start_at')
      else
        # No reservation for the rest of the day ? then return rest of the day
        result << table.time_slot_payload("#{start_time.strftime("%I:%M %p")} - #{now.end_of_day.strftime("%I:%M %p")}")
      end
    end
    result
  end

  def time_slot_payload(time)
    {
      id: id,
      table_number: number,
      number_of_seats: number_of_seats,
      time_slot: time
    }
  end

  def has_reservations_today?
    reservations.where(start_at: Time.zone.now..Time.zone.now.end_of_day).exists?
  end

  def self.best_table(seats)
    tables = where(["number_of_seats = ?", "#{seats}"])
    return tables if tables.exists?

    table_seats = where(["number_of_seats > ?", "#{seats}"]).order(:number_of_seats).first&.number_of_seats

    return [] unless table_seats

    where(["number_of_seats = ?", "#{table_seats}"])
  end

  def has_available_slot?(start_at, end_at)
    return false if reservations.where(start_at: start_at).exists?

    return false if reservations.where("start_at < '#{start_at}' AND end_at > '#{start_at}'").exists?

    return false if reservations.where("start_at > '#{start_at}' AND start_at < '#{end_at}'").exists?

    true
  end
end
