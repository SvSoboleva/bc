class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def show
    @model = @list
    @books = BookList.where(list: @list).map(&:book)
    @sections = Section.all
    @lists = List.where(user: current_user)
    @chats = Chat.all
    render 'books/index'
  end

  def new
    @list = current_user.lists.build
  end

  def edit
  end

  def create
    @list = current_user.lists.build(list_params)

    if @list.save
      redirect_to root_path, notice: I18n.t('controllers.lists.created')
    else
      render :new
    end
  end

  def update
    if @list.update(list_params)
      redirect_to root_path, notice: I18n.t('controllers.lists.updated')
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to root_path, notice: I18n.t('controllers.lists.destroyed')
  end

  private

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:user_id, :name)
    end
end
