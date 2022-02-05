class Table < ApplicationRecord
  MIN_NUMBER_OF_SEATS = 1
  MAX_NUMBER_OF_SEATS = 12

  validates :number_of_seats, presence: true, inclusion: MIN_NUMBER_OF_SEATS..MAX_NUMBER_OF_SEATS
  validates :number, presence: true, numericality: { greater_than: 0 }
end