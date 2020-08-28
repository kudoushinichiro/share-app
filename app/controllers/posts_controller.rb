class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  # require_loginメソッドにより、ログインしていないユーザは上記５つのアクションを実行できない

  def index
    # @posts = Post.all このままだとuser_idについてsqlが多量発行される（N+1）
    # 参考記事：https://qiita.com/TsubasaTakagi/items/8c3f4317ad917924b860
    # orderはrailsのActiveRecordメソッドのひとつ。()内記述で並び順を変更できる。descは降順

    # .pageはkaminariの機能でページの情報を取得できる
    # params[:page]により現在のページパラメーターを受け取っている
    # kaminariのデフォルト設定により最初のページはparamsを無視する（config.params_on_first_page = false）
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
    # 見本に合わせた形で記述しましたが、以下疑問点です。
    # @post = Post.find(params[:id])でない理由はなんでしょう？？
    # current_userをつけることで、何かの間違いで別ユーザがeditできてしまう事故を防いでいる？
    # コメントの方の記述の方が良く見かける形で一般的なのではと考えています。
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      redirect_to posts_path, success: '投稿を削除しました'
    else
      # 万が一削除に失敗した場合はフラッシュを表示し、直前ページに戻る仕様にした。
      # （削除場所がindexページとshowページの2パターンあるため）
      flash.now[:danger] = '投稿の削除に失敗しました'
      redirect_back(fallback_location: root_path)
      # 失敗するケースが想定できなかったため動作確認できてません
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, images: []).merge(user_id: current_user.id)
  end
end
