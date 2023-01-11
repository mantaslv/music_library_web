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
    it 'contains h1 title' do
      response = get('/albums')
      expect(response.body).to include("<h1>Albums</h1>")
      
    end
    it 'contains a links' do
      response = get('/albums')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      expect(response.body).to include('<a href="/albums/1">Doolittle</a>')
    end
  end

  context "GET /artists" do
    it 'contains h1 title' do
      response = get('/artists')
      expect(response.body).to include("<h1>Artists</h1>")
      
    end
    it 'contains a links' do
      response = get('/artists')
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
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include("Artist: Pixies")
    end
  end

  context "GET /albums/:id for id = 2" do
    it "contains h1 title" do
      response = get('/albums/2')
      expect(response.body).to include("<h1>Surfer Rosa</h1>")
    end
    it "contains paragraph" do
      response = get('/albums/2')
      expect(response.body).to include("Release year: 1988")
      expect(response.body).to include("Artist: Pixies")
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

  context "GET /albums/new" do
    it "returns the form page" do
      response = get('/albums/new')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Add an Album</h1>")

      expect(response.body).to include('<form action="/albums" method="POST">')
    end
  end

  context "POST /albums" do
    it 'returns a success page' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: 2022,
        artist_id: 2
      )

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Your album has been added!</p>')
    end

    it 'responds with 400 status if parameters are invalid' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: 2022,
        artist_id: nil
      )

      expect(response.status).to eq 400
    end
  end

  context "GET /artists/new" do
    it "returns the form page" do
      response = get('/artists/new')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Add an Artist</h1>")

      expect(response.body).to include('<form action="/artists" method="POST">')
    end
  end

  context "POST /artists" do
    it 'returns a success page' do
      response = post(
        '/artists',
        name: 'Fred Again',
        genre: 'Dance'
      )

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Your artist has been added!</p>')
    end

    it 'responds with 400 status if parameters are invalid' do
      response = post(
        '/artists',
        title: 'Voyage',
        genre: nil
      )

      expect(response.status).to eq 400
    end
  end
end