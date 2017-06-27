module ApplicationHelper
  def book_img(book)
    if book.book_url?
      book.book_url.url
    else
      asset_path('kniga.jpg')
    end
  end
end
