class ArtistsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
                     .reject { |artist| artist.albums.empty? }
  end

  def show
    @artist = Artist.find(params[:id])
  end
end
