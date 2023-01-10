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
    it 'returns 200 OK' do
      response = get('/albums')
      expected_response = 'Doolittle, Surfer Rosa'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it 'returns 200 OK' do
      post('/albums?title=Voyage&release_year=2022&artist_id=2')
      response = get('/albums')
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
end
