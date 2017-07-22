require 'book_search'
class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_book, only: [:show, :create_booklist]
  before_action :set_current_user_book, only: [:edit, :update, :destroy]
  include BookSearch

  def index
    if params[:query]
      @books = Book.where("title LIKE '%#{params[:query]}%' OR author LIKE '%#{params[:query]}%'")
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
    # если нет обложки, ищем в сети
    @books_from_net = []
    @books_from_net = BookSearch.search(params[:book][:title]) unless params[:book].key?('book_url')

    if @books_from_net == [] # не нашли или обложка уже есть, сохраняем книгу
      if @book.save
        redirect_to root_path, notice: I18n.t('controllers.books.created')
      else
        render :new
      end
    else # предлагаем выбор обложки
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
    if BookList.where(book: @book) == []
      @book.destroy
      redirect_to root_path, notice: I18n.t('controllers.books.destroyed')
    else
      redirect_to book_path(@book), notice: I18n.t('controllers.books.nodelete')
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

  def create_search
    new_book = current_user.books.build
    new_book.title = @books_from_net[params[:id].to_i][:title]
    new_book.auther = @books_from_net[params[:id].to_i][:author]
    new_book.description = @books_from_net[params[:id].to_i][:description]
    new_book.book_url = @books_from_net[params[:id].to_i][:image_url]
    new_book.section_id = Section.where(name: 'Художественная')
    new_book.save
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
