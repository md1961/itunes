class AlbumsController < ApplicationController

  def index
    @artist_initial_ranges, @initial_range = prepare_artist_initial_ranges
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

  def remove_label
    album = Album.find(params[:id])
    label = Albums::Label.find(params[:label_id])
    album.remove_label(label)
    redirect_to album
  end
end
