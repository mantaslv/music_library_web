require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_all_tables
    seed_sql = File.read('spec/seeds/seeds_test.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_all_tables
  end

  context "GET /albums" do
    it 'returns multiple Divs' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      expect(response.body).to include('<a href="/albums/1">Doolittle</a>')
    end
  end


  context "GET /artists" do
    it 'returns 200 OK' do
      response = get('/artists')
      expect(response.body).to include("<h1>Artists</h1>")
      expect(response.body).to include('<a href="/artists/2">ABBA</a>')
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
    end
  end

  context "GET /albums/:id for id = 1" do
    it "contains h1 title" do
      response = get('/albums/1')
      expect(response.body).to include("<h1>Doolittle</h1>")
    end
    it "contains paragraph" do
      response = get('/albums/1')
      regex = "<p>\n      Release year: 1989\n      Artist: Pixies\n    </p>"
      expect(response.body).to match(regex)
    end
  end
  context "GET /albums/:id for id = 2" do
    it "contains h1 title" do
      response = get('/albums/2')
      expect(response.body).to include("<h1>Surfer Rosa</h1>")
    end
    it "contains paragraph" do
      response = get('/albums/2')
      regex = "<p>\n      Release year: 1988\n      Artist: Pixies\n    </p>"
      expect(response.body).to match(regex)
    end
  end

  context "GET /artists/:id for id = 1" do
    it "contains h1 title" do
      response = get('/artists/1')
      expect(response.body).to include("<h1>Pixies</h1>")
    end
    it "contains paragraph" do
      response = get('/artists/1')
      expect(response.body).to include("Genre: Rock")
    end
  end
  context "GET /artists/:id for id = 2" do
    it "contains h1 title" do
      response = get('/artists/2')
      expect(response.body).to include("<h1>ABBA</h1>")
    end
    it "contains paragraph" do
      response = get('/artists/2')
      expect(response.body).to include("Genre: Pop")
    end
  end

end

