# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id)
#  fk_rails_...  (follower_id => users.id)
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  # class_name: 'User'と補足設定することで、存在しないモデルを参照することを防いでいる。
  # 要はどちらも"belongs_to :user"ということ。

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # どちらか一方でもない場合は保存できない

  validates :follower_id, uniqueness: { scope: :followed_id }
  # この記述でfollower_idとfollowed_idの組をuniqueにした。１通りのみ許可のバリデーション。
  # いいね機能の実装時と同じ。
end
