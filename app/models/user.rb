# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # userは、複数のpost/複数のcommentを持つ
  # dependent: :destroyを設定することで、userを削除したときアソシエーション先（この場合はpost・comment）にもdestroyアクションを実行することができる（削除できる）

  has_many :likes, dependent: :destroy
  # ↓いいねをしたpostを取得するための記述
  has_many :like_posts, through: :likes, source: :post
  # throughオプションは指定したテーブルを経由して関連先のデータを取得できるようになるオプション。
  # "has_many :like_posts, through: :likes"のままではlikesテーブルを経由した後の参照先が不明。(like_postsはテーブル名ではなく独自に設定したメソッド名のようなもの？)
  # sourceオプションにより参照先のテーブルを明示することができる。
  # 'source: :post'としてあげれば、likesテーブルを経由しpostsテーブルのデータを取得してくることができる。

  # 〜〜なぜわざわざsourceオプションを使ってまでlike_postsという項目を作っているのか考察〜〜
  # 「userがいいねしたpostを取得したい」ということであれば、"has_many :posts, through: :likes"でも良いように一見考えられるが、
  # userとpostの間には既にアソシエーションが組まれており、そこに新たな関係性を追加することはできないためlike_postsという項目を設定する必要がある。


  validates :username, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
end
