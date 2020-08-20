# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  # uploaderファイルをimagesカラムに適用
  # 複数画像を取り扱いのでuploadersと複数形にする

  serialize :images, JSON
  # carrierwaveで複数画像を保存する場合はJSON型で扱う必要がある。
  # DBをJSON型で設定していないケースでは、modelにて設定する。

  belongs_to :user
  # postは１つのuserを持つ、というアソシエーション
  # この記載がないと、参照先(この場合はuser)テーブルにアクセスできない

  validates :body, presence: true, length: { maximum: 255 }
  validates :images, presence: true
  # migrationファイルでnullfalseをつけたものはこちらでもバリデーションをつける。
  # bodyはなんとなく最大255文字までにしたけど、一般的に何文字くらいにするのがよいのだろう？

end
