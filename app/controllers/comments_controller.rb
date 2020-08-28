class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.create(comment_params)
    # current_userを指定してコメントのcreateを実行する
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id, post_id: params[:post_id])
    # user_idとpost_idをcommentに紐づけて保存出来るようにする
    # もしかしてmerge(user_id: current_user.id)って必要ないのでしょうか？
    # current_user.comments.create(comment_params)ですでにuser_idを取得できている？
  end

end
