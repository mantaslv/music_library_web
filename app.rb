# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    album_repository = AlbumRepository.new
    @albums = album_repository.all
    return erb(:albums)
  end

  get '/artists' do
    artist_repository = ArtistRepository.new
    @artists = artist_repository.all
    return erb(:artists)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/albums/:id' do
    id = params[:id]
    album_repository = AlbumRepository.new
    artist_repository = ArtistRepository.new
    album = album_repository.find(id)
    artist_id = album.artist_id
    artist = artist_repository.find(artist_id)
    @title = album.title
    @release_year = album.release_year
    @artist = artist.name
    return erb(:album)
  end

  get '/artists/:id' do
    id = params[:id]
    artist_repository = ArtistRepository.new
    artist = artist_repository.find(id)
    @name = artist.name
    @genre = artist.genre
    return erb(:artist)
  end

  post '/albums' do
    if invalid_album_parameters?
      status 400
      return ''
    end
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    AlbumRepository.new.create(album)
    return erb(:new_album_added)
  end

  post '/artists' do
    if invalid_artist_parameters?
      status 400
      return ''
    end
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    ArtistRepository.new.create(artist)
    return erb(:new_artist_added)
  end

  def invalid_album_parameters?
    params[:title] == nil ||
    params[:release_year] == nil ||
    params[:artist_id] == nil
  end

  def invalid_artist_parameters?
    params[:name] == nil ||
    params[:genre] == nil
  end
end