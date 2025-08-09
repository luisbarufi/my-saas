# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'luisbarufi@gmail.com', password: '123@456', password_confirmation: '123@456')
Tenant.create!(name: "BarufiTech")
Member.create!(tenant: Tenant.first, user: User.first, admin: true)
User.update_all confirmed_at: DateTime.now

