# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def find_or_create_user(employee_number, role)
  User.find_or_create_by(employee_number: employee_number) do |user|
    user.password = '123456'
    user.name = 'Abdullah'
    user.role = role
  end
end

find_or_create_user('1000', User::ROLE_ADMIN)
find_or_create_user('2000', User::ROLE_EMPLOYEE)