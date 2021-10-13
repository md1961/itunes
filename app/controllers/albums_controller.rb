class AlbumsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
  end

  def show
    album = Album.find(params[:id])
    @albums = album.albums_in_set
  end
end
