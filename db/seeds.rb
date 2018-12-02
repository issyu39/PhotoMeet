# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザー
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             location: "Spain",
             age:  "13",
             position: "Model",
             description: "Example User",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

             
49.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  location = "United States"
  age = "22"
  position = "Photographer"
  description = Faker::Lorem.sentence(5)
  password = "password"
  User.create!(name:  name,
               email: email,
               location: location,
               age: age, 
               position: position,
               description: description,
               password:              password,
               password_confirmation: password)
end

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+50}@railstutorial.org"
  location = "Canada"
  age = "26"
  position = "Model"
  description = Faker::Lorem.sentence(5)
  password = "password"
  User.create!(name:  name,
               email: email,
               location: location,
               age: age, 
               position: position,
               description: description,
               password:              password,
               password_confirmation: password)
end

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# イベント
Event.create!(title:  "紅葉撮影会",
             content: "みんなで紅葉を撮りましょう。 撮影会の後は懇親会もあるのでお気軽にご参加ください。",
             location: "香嵐渓",
             date: "2018-11-21"
             )

Event.create!(title: "名古屋撮影会",
             content: "TEXT TEXT TEXT TEXT",
             location: "庄内緑地公園",
             date: "2018-12-21"
             ) 
 
             
# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }