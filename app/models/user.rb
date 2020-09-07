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


  # ※課題６での重要ポイントな気がしています。もし認識が間違っていたらご指摘ください！
  # userとrelationshipについてアソシエーションを組む必要がある。簡潔に"has_many :relationships"としたい所だが、
  # relationshipテーブルに２つあるカラムはどちらもuserテーブルに紐づく中間テーブルとなっており、どちらのカラムとのアソシエーションなのかをしっかり区別してあげる必要がある。
  # よって、以下２パターンのアソシエーションを記述するということになる。
  # ↓①
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # "User"とRelationshipテーブルの「follower_id」とのアソシエーションを設定している。
  # active_relationshipsとしているため、class_nameでテーブル名を明示。かつforeign_key設定により参照するカラムも指定。
  has_many :following, through: :active_relationships, source: :followed
  # "User"が「フォローをしている相手」を取得できるようにするための記述。
  # 上記で設定した"active_relationships"を経由し、"followed_id"を持つuserを関連付ける。
  # user.followingを実行する→→"active_relationships"を経由する(userは自身のidを元にRelationテーブル/follower_idを参照)→→sourceオプションにより、idが一致したレコードの"followed_id"データを取得できる
  # ↓②
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  # "User"が「フォローを受けている相手」を取得できるようにするための記述。
  # 上記と考え方は同じ。違うのは、Userの"user_id"をRelationshipテーブルのどのカラムで探しているかということ。
  # 今回は、user.followersを実行する→→"passive_relationships"を経由する(userは自身のidを元にRelationテーブル/followed_idを参照)→→sourceオプションにより、idが一致したレコードの"follower_id"データを取得できる


  def like(post)
    like_posts << post
    # current_userが持つ"like_posts"を配列形式とし、コントローラーより受け取った"postオブジェクト(いいねしようとしている投稿)"を
    # いいねするたびに格納していくという処理。
  end

  def unlike(post)
    like_posts.destroy(post)
    # current_userが持つ"like_posts"に格納されているpost(コントローラーから受け取ったpost)を削除する。
  end

  def like?(post)
    like_posts.include?(post)
    # current_userが持つ"like_posts"にview(_like_area)より受け取った"postオブジェクト"が格納されているかどうかを確認する。
    # 配列current_userが、postと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  def follow(other_user)
    following << other_user
    # current_userが持つ"followings"を配列形式とし、コントローラーより受け取った"other_userオブジェクト(@userのこと)"を
    # フォローするたびに格納していくという処理。
  end

  def unfollow(other_user)
    following.destroy(other_user)
    # current_userが持つ"followings"に格納されているother_user(コントローラーから受け取った@user)を削除する。
  end

  def following?(other_user)
    following.include?(other_user)
    # current_userが持つ"followings"にview(_follow_area)より受け取った"userオブジェクト"が格納されているかどうかを確認する。
    # 配列followingsが、userと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  # ※※ここの部分の理解が曖昧な状態です・・・※※
  def feed
    Post.where(user_id: following_ids << id)
    # postの中から、post.user_idが条件に一致するものを探す。
    # whereは条件に合うレコードを全て返す処理を行う。
    # この場合は"user_id"が"following_ids << id"であるデータとなる。
    # 現状followingは配列のように扱っており、中にはuserのオブジェクトが格納されている。
    # following_idsとすることで、一つ一つのuserオブジェクトの中のid部分のみ条件指定している。
    # followingにはcurrent_userは含まれないので、"<< id"の記述で自身のidも追加している。(記述を外したら自身の投稿は一覧から消えた)
    # これで無事、フォローしたユーザのid + 自分のid をwhereの条件とすることができる。
  end

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  # 作成順での並び替え。(count)で数字を引数として受け取れる。

  validates :username, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
end
