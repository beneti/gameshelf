class BggCrawler
  attr_reader :games

  def initialize(username)
    @username = username
    @agent = Mechanize.new
  end

  def parse_games
    Rails.cache.fetch(@username, expire_in: 1.minute) do
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

  private

  def url
    "https://boardgamegeek.com/geekcollection.php?ajax=1&action=collectionpage&username=#{@username}&sort=title&pageID=1&ff=1&columns[]=title&columns[]=thumbnail&own=1"
  end

end
