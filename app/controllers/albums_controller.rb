class AlbumsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
  end

  def show
    album = Album.find(params[:id])
    @albums = album.albums_in_set
  end

  def put_label
    album = Album.find(params[:id])
    label = Albums::Label.find_by(id: params[:label_id])
    album.put_label(label) if label
    redirect_to album
  end
end
