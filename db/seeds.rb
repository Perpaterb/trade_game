# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!([
    {email: "admin1@test.com", username: "admin1", password: "abc123", password_confirmation: "abc123", admin: true, signinstep: 2}
    # {email: "bot1@test.com", username: "bot1", password: "abc123", password_confirmation: "abc123", admin: false, signinstep: 2},
    # {email: "bot2@test.com", username: "bot2", password: "abc123", password_confirmation: "abc123", admin: false, signinstep: 2},
    # {email: "bot3@test.com", username: "bot3", password: "abc123", password_confirmation: "abc123", admin: false, signinstep: 2}
  ])

# Holding.create!([
#     {owner_users_ID: 4, stock_code: "AGL", quantity: 10, asking: 0},
#     {owner_users_ID: 2, stock_code: "BHP", quantity: 10, asking: 0},
#     {owner_users_ID: 3, stock_code: "CBA", quantity: 10, asking: 0},
#     {owner_users_ID: 4, stock_code: "AMP", quantity: 100, asking: 0},
#     {owner_users_ID: 2, stock_code: "ANZ", quantity: 100, asking: 6},
#     {owner_users_ID: 3, stock_code: "WOW", quantity: 100, asking: -05},
#     {owner_users_ID: 4, stock_code: "TLS", quantity: 100, asking: 30},
#     {owner_users_ID: 2, stock_code: "SUN", quantity: 100, asking: -05},
#     {owner_users_ID: 3, stock_code: "RIO", quantity: 100, asking: -03},
#     {owner_users_ID: 2, stock_code: "ANZ", quantity: 240, asking: 6},
#     {owner_users_ID: 2, stock_code: "ANZ", quantity: 202, asking: 6},
#     {owner_users_ID: 4, stock_code: "AUD", quantity: 10000, asking: 0},
#     {owner_users_ID: 2, stock_code: "AUD", quantity: 10000, asking: 0},
#     {owner_users_ID: 3, stock_code: "AUD", quantity: 10000, asking: 0}
#   ])

#   Transaction.create!([
#     {sold_user_id: 4, buying_user_id: 3, stock_code: "AGL", quantity: 100, price_per_share: 1400},
#     {sold_user_id: 3, buying_user_id: 4, stock_code: "AGL", quantity: 100, price_per_share: 1400},
#     {sold_user_id: 2, buying_user_id: 3, stock_code: "BHP", quantity: 100, price_per_share: 3400},
#     {sold_user_id: 3, buying_user_id: 2, stock_code: "BHP", quantity: 100, price_per_share: 3400},
#     {sold_user_id: 3, buying_user_id: 2, stock_code: "CBA", quantity: 100, price_per_share: 2400},
#     {sold_user_id: 2, buying_user_id: 3, stock_code: "CBA", quantity: 100, price_per_share: 2400}
#   ])

#   StartCartItem.create!([
#     {owner_users_id: 1, stock_code: "AGL", quantity: 100},
#     {owner_users_id: 1, stock_code: "SUN", quantity: 50}
#   ])

  Leaderboard.create!([
    {username: "timer", net_worth: 1}
  ])