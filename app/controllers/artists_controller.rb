class ArtistsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
  end

  def show
    @artist = Artist.find(params[:id])
  end
end
