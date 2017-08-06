module BookSearch
 # books_from_ozon = BookRetriever.search(params[:author], params[:book_name])


  def self.search(book_name, author)
    books = []

    @agent = Mechanize.new()
    @agent.follow_meta_refresh = true
    @agent.set_proxy(@proxy, @port) unless @proxy.nil?
    @agent.keep_alive = false
    @agent.user_agent = "Opera/9.80 (Windows NT 5.1; U; en) Version/10.1"

    link = "http://www.ozon.ru/?context=search&text=#{book_name}+#{author}&group=div_book&store=1,0"
    page = @agent.get(link)

    # Ищем блоки с книгами
    book_block = page.search("//div[@itemprop='itemListElement']")

    book_block.each do |item|
      book_title =  item.search("div[@itemprop='name']").text.squish
      author_name = item.search("div.bOneTileProperty").text.squish

      # если есть совпадения с нашими данными, получаем ссылку на книгу
      if book_title =~ /#{book_name}/i && author_name =~ /#{author}/i
        book_link = item.search("a[@itemprop='url']/@href")
        book = parse_book(book_link, @agent, book_title, author_name)
        books.concat book
        break
      end
    end

    return books
  end

  def self.parse_book(link, agent, title, author)
    # Полная ссылка на страницу
    link = "http://www.ozon.ru#{link}"

    # Переход на страницу
    page = agent.get(link)
    book_description = page.search("//div[@class='eItemDescription_text']").text.squish
    book_image = "http:" + page.search("img.eMicroGallery_fullImage.mVisible/@src").to_s

    # Добавление книги
    new_book = {
      title: title,
      author: author,
      description: book_description,
      image_url: book_image
    }

    return [new_book]
  end
end