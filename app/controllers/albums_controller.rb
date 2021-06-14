class AlbumsController < ApplicationController

  def index
    @artists = Artist.all.sort
    @albums_by_artist = Album.includes(:artist, :tracks)
                             .group_by(&:artist)
                             .map { |artist, albums|
                               [
                                 artist,
                                 albums.sort_by { |album|
                                   [album.year || 999999]
                                 }
                               ]
                             }.to_h
  end
end
