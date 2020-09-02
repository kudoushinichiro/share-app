# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id  (post_id)
#  index_likes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 一つのいいねには、必ず一人のユーザーと一つの投稿が紐づく

  validates :user_id, uniqueness: { scope: :post_id }
  # この記述でpost_idとuser_idの組をuniqueにした。１通りのみ許可のバリデーション。
  # uniquenessはRails Validationヘルパーの一つ。
  # 属性の値が一意（unique）であり重複していないことを検証する。
  # 属性について同じ値のレコードがモデルにあるかをクエリを走らせ確認する。
  # scopeオプションは他のカラムに一意性制約を求めることが出来る。
  # 今回のケースだと、ひとつの":user_id"シンボルに紐づくscope先の"post_id"カラムのレコードに対しuniquenessを実行している。
end
