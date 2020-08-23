puts "Postテーブルにseedデータを投入します"

User.limit(3).each do |user|
  # 以下がuser数分繰り返し実行される
  # limit(n)と制限をつけると、user_idの1〜n番までのuserがダミーのpostを実行する
  # 仮にこの中に正規のuserがいてもseedデータの投入がされる模様。注意
  post = user.posts.create(body: Faker::Coffee.blend_name, remote_images_urls: %w[https://picsum.photos/350/350/?random https://picsum.photos/350/350/?random])
  puts "post#{post.id}が作成されました"

end