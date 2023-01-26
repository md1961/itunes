class AlbumsController < ApplicationController

  def index
    @artist_initial_ranges = ArtistInitialRange.all
    @initial_range = params[:initial_range].yield_self { |name|
      if name.nil?
        @artist_initial_ranges.first
      else
        @artist_initial_ranges.detect { |range|
          range.name == name
        }
      end
    }
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
