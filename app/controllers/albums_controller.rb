class AlbumsController < ApplicationController

  def index
    @artists = [Artist::COMPILATION] + Artist.all.sort

    @albums_by_artist = Album.includes(:artist, :tracks)
                             .group_by(&:artist)
                             .map { |artist, albums|
                               # Album#artist is nil if it's compilation.
                               [artist || Artist::COMPILATION, albums.sort]
                             }.to_h
  end
end
