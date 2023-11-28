class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  def index
    if params[:folder_id].present?
      @comments = current_user.comments.where(folder_id: params[:folder_id])
    else
      @comments = current_user.comments
    end
  end

  # GET /comments/new
  def new
    @comment = current_user.comments.new
    @folders = current_user.folders
  end

  # POST /comments
  def create
    @comment = current_user.comments.new(comment_params)
    # フォルダが選択されていない場合はデフォルトフォルダを設定
    @comment.folder_id = current_user.folders.find_by(name: 'ノーマル').id if @comment.folder_id.blank?

    if @comment.save
      redirect_to @comment, notice: '感想が正常に記録されました。'
    else
      @folders = current_user.folders
      render :new
    end
  end

  # GET /comments/1/edit
  def edit
    @folders = current_user.folders
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: '感想が正常に更新されました。'
    else
      @folders = current_user.folders
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: '感想が正常に削除されました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = current_user.comments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:title, :content, :folder_id)
    end
end
