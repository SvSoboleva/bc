class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  def show
    @model = @chat
    @new_comment = @chat.comments.build(params[:comment])
  end

  def new
    @chat = current_user.chats.build
  end

  def edit
  end

  def create
    @chat = current_user.chats.build(chat_params)

    if @chat.save
      redirect_to root_path, notice: I18n.t('controllers.chats.created')
    else
      render :new
    end
  end

  def update
    if @chat.update(chat_params)
      redirect_to root_path, notice: I18n.t('controllers.chats.updated')
    else
      render :edit
    end
  end

  def destroy
    @chat.destroy
    redirect_to root_path, notice: I18n.t('controllers.chats.destroyed')
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:user_id, :theme)
  end
end
