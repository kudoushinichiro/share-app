class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
      t.index [:follower_id, :followed_id], unique: true
      # follower_idとfollowed_idの組み合わせにユニーク制約をする。

      # 見本ではそれぞれのカラムに対してindexが貼られていたが、見本と違い"references型"で
      # カラムを作成したためか、schemaでは既にindexが適用されていたため記述省略。
      # →なぜ見本ではintger型なのか？
      # いいねモデルと同じく、references型で良いのでは？と思っています。もし理由があるなら教えていただけるとありがたいです。
    end
  end
end
