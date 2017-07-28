class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_filter :set_commentable, only: [:create]

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = @commentable
    @comment.user = current_user

    if @comment.save
      redirect_to book_path(params[:book_id]), notice: I18n.t('controllers.comments.created') if params[:commentable_type] == 'Book'
      redirect_to chat_path(params[:chat_id]), notice: I18n.t('controllers.comments.created')if params[:commentable_type] == 'Chat'
    else
      render 'books/show', alert: I18n.t('controllers.comments.error') if params[:commentable_type] == 'Book'
      render 'chats/show', alert: I18n.t('controllers.comments.error') if params[:commentable_type] == 'Chat'
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.comments.destroyed') }

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = { alert: I18n.t('controllers.comments.error') }
    end

    redirect_to  book_path(params[:book_id]), message if params[:commentable_type] == 'Book'
    redirect_to chat_path(params[:chat_id]), message if params[:commentable_type] == 'Chat'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    commentable_id = params["#{params[:commentable_type].underscore}_id"]
    @commentable = params[:commentable_type].constantize.find(commentable_id)
  end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
