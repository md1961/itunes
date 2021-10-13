class ArtistsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
                     .reject { |artist| artist.albums.empty? }
  end

  def show
    if params[:id].to_i.zero?
      @artist = Artist::COMPILATION
    else
      @artist = Artist.find(params[:id])
    end
  end
end
