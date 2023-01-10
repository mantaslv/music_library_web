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
      response = get('/albums_divs')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include("Title: Surfer Rosa")
      expect(response.body).to include("Title: Doolittle")
      expect(response.body).to include("Released: 1989")
      expect(response.body).to include("Released: 1988")

    end
  end

  xcontext "POST /albums" do
    it 'returns 200 OK' do
      post('/albums?title=Voyage&release_year=2022&artist_id=2')
      response = get('/albums_divs')
      print response.body
      expected_response = 'Doolittle, Surfer Rosa, Voyage'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "GET /artists" do
    it 'returns 200 OK' do
      response = get('/artists')
      expected_response = 'Pixies, ABBA'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /artists" do
    it 'returns 200 OK' do
      post('/artists?name=Wild nothing&genre=Indie')
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Wild nothing'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
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

end

