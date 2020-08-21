puts "Userテーブルにseedデータを投入します"

2.times do
  # 以下が設定回数繰りかえされる。
  user = User.create(
    email: Faker::Internet.unique.email,
    username: Faker::Internet.unique.user_name,
    password: 'password',
    password_confirmation: 'password'
  )

  puts "\"#{user.username}\" を作成しました"
  # 文字列の中で " を使うには \" と記述する
end