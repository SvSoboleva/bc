require 'book_search'
class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_book, only: [:show, :create_booklist, :edit, :update, :destroy]
  include BookSearch

  def index
    if params[:query]
      @books = Book.search(params[:query])
    else
      @books = Book.all
    end
    @model = []
    @sections = Section.all
    @lists = List.where(user: current_user)
    @chats = Chat.all
  end

  def show
    @model = @book
    @new_comment = @book.comments.build(params[:comment])
  end

  def new
    @book = current_user.books.build
  end

  def edit
    @comment_search = 'edit'
  end

  def create
    @book = current_user.books.build(book_params)
    @comment_search = ''

    # поиск обложки в сети при наличии названия книги
    if params[:commit] == 'поиск книги' &&
       params[:book][:title] != '' &&
       params[:book][:author] != ''

      # проверяем, есть ли уже такая книга, и переходим к найденной книге
      @books = Book.search("#{params[:book][:title]} #{params[:book][:author]}")
      if @books && @books != []
        redirect_to book_path(@books[0][:id]), notice: 'Такая книга уже есть в нашей библиотеке'
      else
        # поиск книги в сети
        @books_from_net = []
        @books_from_net = BookSearch.search(params[:book][:title],
                                            params[:book][:author]) unless params[:book].key?('book_url')
        @comment_search = 'Книга не найдена' if @books_from_net == []
        render :new
      end
    # выбрана найденная в сети книги, добавляем в библиотеку
    elsif params[:commit] == 'выбрать' && params[:id_search]
      @book.author = params[:id_author]
      @book.title = params[:id_title]
      @book.description = params[:id_description]
      @book.remote_book_url_url = params[:id_image_url]
      if @book.save
        redirect_to book_path(@book), notice: I18n.t('controllers.books.created')
      else
        render :new
      end
    # заполнили форму вручную, добавляем книгу
    elsif @book.save
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
    if BookList.where(book: @book) == []
      @book.destroy
      redirect_to root_path, notice: I18n.t('controllers.books.destroyed')
    else
      redirect_to book_path(@book), notice: I18n.t('controllers.books.nodelete')
    end
  end

  # добавление книги в список пользователя
  def create_booklist
    # проверка: книга есть в выбранном списке - о чем и сообщаем
    if BookList.where(book: @book, list: List.find(params[:query])).exists?
      redirect_to @book, notice: I18n.t('controllers.books.alreadyadded')

    # проверка: книга есть в одном из списков - переносим в выбранный список
    elsif BookList.where(book: @book, list: List.where(user_id: current_user.id)).exists?
      BookList.where(book: @book, list: List.where(user_id: current_user.id)
                    ).update(list: List.find(params[:query]))
      redirect_to @book, notice: I18n.t('controllers.books.moved')

    # добавляем книгу в список
    else
      BookList.create!(book: @book, list: List.find(params[:query]))
      redirect_to @book, notice: I18n.t('controllers.books.add')
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :book_url, :description, :section_id)
  end
end
