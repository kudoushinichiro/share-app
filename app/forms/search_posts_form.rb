# 検索のための新たなクラスを作成
class SearchPostsForm
  include ActiveModel::Model
  # DBを介さずActiveRecordを利用している時のような機能を得る
  # DBに保存せずにform_withで処理を返すことができるようになる
  include ActiveModel::Attributes
  # 属性を指定の型へ変換してくれる

  attribute :body, :string
  # 型の指定をしている。
  # キーがbodyのものはstring型となる。

  def search
    # posts_controllerのsearchアクションで実行される。
    # (application_controllerで定義した@search_formに対して)
    scope = Post.distinct
    # 重複を除外している。
    scope = scope.body_contain(body) if body.present?
    # 重複を除外したscope(Post)に対して、（入力があった場合のみ）postモデルで設定した検索メソッド（スコープ）を実行。
    scope
    # 1行上の"if body.present?"がfalseだった場合にnilが返ってしまうのを回避するためのscope

    # 疑問なのですが・・・
    # 上記は以下のようにも書き換えられると思うのですが、（実際動く）
    # このように書くのはあまり推奨されないのでしょうか？
    # 上記の記法は馴染みがなく理解に苦戦してしまった（質問フォームではお世話になりました！）
    # if body.present?
    #   scope = scope.body_contain(body)
    # else
    #   scope
    # end
  end
end
