class BggCrawler
  attr_reader :games

  def initialize(username)
    @username = username
    @agent = Mechanize.new
  end

  def get_owned_games
    parsed_games(own_url)
  end

  def get_wishlisted_games
    parsed_games(wishlist_url)
  end

  private

  BASE_URL = "https://boardgamegeek.com/geekcollection.php?ajax=1&action=collectionpage&sort=title&pageID=1&ff=1&columns[]=title&columns[]=thumbnail"

  def parsed_games(url)
    Rails.cache.fetch(url.gsub(BASE_URL,''), expire_in: 1.minute) do
      @games = []
      @page = @agent.get(url)
      @page.root.search('#collectionitems > tr:gt(1)').each do |tr|
        @img = tr.search('td a img').first.attributes['src'].text.gsub(/_mt/, '_md')
        @title = tr.search('td a').last.text
        @games.push({img: @img, title: @title})
      end
      @games
    end
  end

  def own_url
    "#{BASE_URL}&username=#{@username}&own=1"
  end

  def wishlist_url
    "#{BASE_URL}&username=#{@username}&wishlist=1"
  end

end

