# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
(1..100).each do |i|
  Post.create(title: "title#{i}", content: "content#{i}")
end

# id 3개를 만들고, 각각 게시글 3개를 만듬
(1..3).each do |i|
  User.create(email: "test#{i}@test.com", password: "123456", password_confirmation: "123456")
  (1..3).each do |j|
    Board.create(user_id: i, title: "title#{i}_#{j}", content: "content#{i}_#{j}")
  end
end

