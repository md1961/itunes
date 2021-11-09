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
    label = Albums::Label.find(params[:label_id])
    Album.transaction do
      album.albums_in_set.each do |album|
        album.put_label(label)
      end
    end
    redirect_to album
  end
end
