class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_book, only: [:show, :create_booklist]
  before_action :set_current_user_book, only: [:edit, :update, :destroy]

  def index
    if params[:query]
      @books = Book.where("title.downcase LIKE '%#{params[:query]}%' OR author.downcase LIKE '%#{params[:query]}%'")
    else
      @books = Book.all
    end
    @model = []
    @sections = Section.all
    @lists = List.where(user: current_user)
  end

  def show
  end

  def new
    @book = current_user.books.build
  end

  def edit
  end

  def create
    @book = current_user.books.build(book_params)

    if @book.save
      redirect_to root_path, notice: I18n.t('controllers.books.created')
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: I18n.t('controllers.books.updated')
    else
      render :edit
    end
  end

  def destroy
    if BookList.where(book: @book)
      redirect_to book_path(@book), notice: I18n.t('controllers.books.nodelete')
    else
      @book.destroy
      redirect_to root_path, notice: I18n.t('controllers.books.destroyed')
    end
  end

  def create_booklist
    if BookList.where(book: @book, list: List.find(params[:query])).exists?
      redirect_to @book, notice: I18n.t('controllers.books.alreadyadded')
    else
      BookList.create!(book: @book, list: List.find(params[:query]))
      redirect_to @book, notice: I18n.t('controllers.books.add')
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_current_user_book
    @book = current_user.books.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :book_url, :description, :section_id)
  end
end
