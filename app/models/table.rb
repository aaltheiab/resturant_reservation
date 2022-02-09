class Table < ApplicationRecord
  MIN_NUMBER_OF_SEATS = 1
  MAX_NUMBER_OF_SEATS = 12

  has_many :reservations

  validates :number_of_seats, presence: true, inclusion: { in: MIN_NUMBER_OF_SEATS..MAX_NUMBER_OF_SEATS,
                                                           message: 'Must Be Within 1 to 12' }
  validates :number, presence: true, numericality: { greater_than: 0 }


  def self.best_match(seats)
    # TODO enhance algorithm to take care of the best options and return the time slots instead of table
    where(["number_of_seats >= ?", "#{seats}"]).order(:number_of_seats).first()
  end

  def has_available_slot?(start_at, end_at)
    return false if reservations.where(start_at: start_at).exists?

    return false if reservations.where("start_at < '#{start_at}' AND end_at > '#{start_at}'").exists?

    return false if reservations.where("start_at > '#{start_at}' AND start_at < '#{end_at}'").exists?

    true
  end
end
