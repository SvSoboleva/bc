module ApplicationHelper
  def book_img(book)
    if book.book_url?
      book.book_url
    else
      asset_path('kniga.jpg')
    end
  end

  # Хелпер для иконок font-awesome
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end
