require "test_helper"

class TableTest < ActiveSupport::TestCase
  test "Happy Case" do
    table = Table.new(number_of_seats: 12, number: 1)
    assert_equal(table.valid?, true)
  end

  test "Exceed allowed # of seats" do
    table = Table.new(number_of_seats: Table::MAX_NUMBER_OF_SEATS + 1, number: 1)
    assert_equal(table.valid?, false)
  end

  test "Below expected # of seats" do
    table = Table.new(number_of_seats: Table::MIN_NUMBER_OF_SEATS - 1, number: 1)
    assert_equal(table.valid?, false)
    assert_equal(table.errors.messages.keys.include?(:number_of_seats), true)
  end

  test "Table number must be positive integer" do
    table = Table.new(number_of_seats: Table::MIN_NUMBER_OF_SEATS, number: 0)
    assert_equal(table.valid?, false)

    table = Table.new(number_of_seats: Table::MIN_NUMBER_OF_SEATS, number: -1)
    assert_equal(table.valid?, false)
  end

  test "Table number uniqueness" do
    Table.create(number_of_seats: Table::MIN_NUMBER_OF_SEATS, number: 1)
    table = Table.new(number_of_seats: Table::MIN_NUMBER_OF_SEATS, number: 1)
    assert_equal(table.valid?, false)
    assert_equal(table.errors.messages.keys.include?(:number), true)
  end

end
