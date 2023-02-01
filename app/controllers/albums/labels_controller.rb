class Albums::LabelsController < ApplicationController
  before_action :set_label, except: %i[index]

  def index
    @labels = Albums::Label.all_for_action_index
  end

  def show
  end

  def edit
    @tab_navi_for_artists = TabNaviForArtists.new(params[:initial_range])
  end

  def add_album
    album = Album.find(params[:album_id])
    album.put_label(@label)
    render json: {"response": "received"}
  end

  def remove_album
    album = Album.find(params[:album_id])
    album.remove_label(@label)
  end

  private

    def set_label
      @label = Albums::Label.find(params[:id])
    end
end
