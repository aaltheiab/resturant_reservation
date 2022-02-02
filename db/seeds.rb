# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(name: 'Abdullah', employee_number: '1000', password: '123456', role: User::ROLE_ADMIN)
User.create!(name: 'Mohammed', employee_number: '2000', password: '123456', role: User::ROLE_EMPLOYEE)