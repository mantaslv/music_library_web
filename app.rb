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
    albums = []
    album_repository.all.each do |record|
      album = record.title
      albums << album
    end
    return albums.join(", ")
  end

  post '/albums' do
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    album_repository = AlbumRepository.new
    album_repository.create(album)
    return nil
  end

  get '/artists' do
    artist_repository = ArtistRepository.new
    artists = []
    artist_repository.all.each do |record|
      artist = record.name
      artists << artist
    end
    return artists.join(", ")
  end

  post '/artists' do
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artist_repository = ArtistRepository.new
    artist_repository.create(artist)
    return nil
  end
end