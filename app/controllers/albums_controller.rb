class AlbumsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation

    @albums_by_artist = Album.includes(:artist, :tracks)
                             .group_by(&:artist)
                             .map { |artist, albums|
                               # Album#artist is nil if it's compilation.
                               [artist || Artist::COMPILATION, albums.sort]
                             }.to_h
  end

  def show
    album = Album.find(params[:id])
    @albums = album.albums_in_set
  end
end
