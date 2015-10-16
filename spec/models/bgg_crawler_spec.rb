require 'spec_helper'

describe BggCrawler do
  describe "when getting own list" do
    before do
      WebMock.stub_request(:get, /.*own.*/).
        to_return(body: File.new('./spec/samples/own.html').read, 
                  status: 200,
                  headers: {content_type: 'text/html'})
        @bgg = BggCrawler.new('beneti')
    end

    it "number of games must be 34" do
      assert_equal @bgg.get_owned_games.count, 34
    end

    it "name of first game must be 7 wonders" do
      assert_equal @bgg.get_owned_games.first[:title], '7 Wonders'
    end

    it "image src of last game must match pic2664015_md" do
      assert_equal @bgg.get_owned_games.last[:img], '//cf.geekdo-images.com/images/pic2664015_md.jpg'
    end
  end

  describe "when getting wishlist" do
    before do
      WebMock.stub_request(:get, /.*wishlist.*/).
        to_return(body: File.new('./spec/samples/wishlist.html').read,
                  status: 200,
                  headers: {content_type: 'text/html'})
        @bgg = BggCrawler.new('beneti')
    end

    it "number of games must be 4" do
      assert_equal @bgg.get_wishlisted_games.count, 4
    end

    it "name of first game must be Ascension: Deckbuilding Game" do
      assert_equal @bgg.get_wishlisted_games.first[:title], 'Ascension: Deckbuilding Game'
    end

    it "image src of last game must match pic158548_md" do
      assert_equal @bgg.get_wishlisted_games.last[:img], '//cf.geekdo-images.com/images/pic158548_md.jpg'
    end
  end

end
