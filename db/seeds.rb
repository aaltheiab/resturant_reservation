# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

def find_or_create_user(employee_number, role)
  User.find_or_create_by(employee_number: employee_number) do |user|
    user.password = '123456'
    user.name = 'Abdullah'
    user.role = role
  end
end

def find_or_create_table(number, seats)
  table = Table.find_or_create_by(id: number) do |table|
    table.number = number
    table.number_of_seats = seats
  end

  return if table.reservations.exists?


  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: (Time.zone.now - 1.day).change(hour: 12, minute: 00),
                     end_at: (Time.zone.now - 1.day).change(hour: 14, minute: 00))

  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: (Time.zone.now - 1.day).change(hour: 14, minute: 00),
                     end_at: (Time.zone.now - 1.day).change(hour: 16, minute: 00))

  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: (Time.zone.now - 1.day).change(hour: 18, minute: 00),
                     end_at: (Time.zone.now - 1.day).change(hour: 20, minute: 00))


  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: Time.zone.now.change(hour: 12, minute: 00),
                     end_at: Time.zone.now.change(hour: 14, minute: 00))

  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: Time.zone.now.change(hour: 14, minute: 00),
                     end_at: Time.zone.now.change(hour: 16, minute: 00))

  Reservation.create(table_id: table.id, customer_name: 'Ahmed', seats: seats,
                     start_at: Time.zone.now.change(hour: 18, minute: 00),
                     end_at: Time.zone.now.change(hour: 20, minute: 00))
end

find_or_create_user('1000', User::ROLE_ADMIN)
find_or_create_user('2000', User::ROLE_EMPLOYEE)

find_or_create_table(1, 1)
find_or_create_table(2, 1)

find_or_create_table(3, 2)
find_or_create_table(4, 2)

find_or_create_table(5, 4)
find_or_create_table(6, 4)

find_or_create_table(7, 12)
find_or_create_table(8, 12)