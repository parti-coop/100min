class CommentsController < ApplicationController
  def index
    load_commentable

    @comments = @commentable.comments.order_recent.page(params[:page])
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def create
    load_commentable

    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      redirect_to @commentable, notice: '댓글이 게시되었습니다.'
    else
      errors_to_flash(@comment)
      session[:error_comment_body] = @comment.body
      redirect_to @commentable
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize @comment

    @comment.assign_attributes(comment_params)
    if @comment.save
      flash[:success] = '저장되었습니다'
    else
      errors_to_flash(@story)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment

    if @comment.destroy
      flash[:success] = '삭제되었습니다'
    else
      errors_to_flash(@comment)
    end

    @commentable = @comment.commentable
    @comments = @commentable.comments.order_recent.page(params[:page])
  end

  private

  def load_commentable
    if params[:commentable_type].present? and params[:commentable_id].present?
      resource = params[:commentable_type].safe_constantize
      if resource.present?
        @commentable = resource.find(params[:commentable_id])
      end
    else
      resource, id = request.path.split('/')[1,2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

