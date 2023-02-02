class AlbumsController < ApplicationController

  def index
    initial_range_name = retrieve_artist_initial_range_name
    @tab_navi_for_artists = TabNaviForArtists.new(initial_range_name)
    store_artist_initial_range_name(initial_range_name)
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
