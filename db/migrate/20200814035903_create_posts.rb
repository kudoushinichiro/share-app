class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :images, null: false
      # 画像は複数登録なのでimagesにしている。
      t.text :body, null: false
      # stringとtextで悩んだ。複数行の記入が想定されるのでtextとした。
      # が、stringは255文字までいけるようなので、stringでもいいのかも？
      t.references :user, foreign_key: true
      # 外部キー制約をつける。t.references :userとすることで、自動でuser_idと認識される。
      # references型を使用する場合はforeign_key: trueをつける必要がある。
      # foreign_key: trueは、"paramsの中にuser_idがありますか？"を問われているものと考えいるがこの認識でよいでしょうか？
      
      t.timestamps
    end
  end
end
