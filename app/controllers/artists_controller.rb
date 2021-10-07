class ArtistsController < ApplicationController

  def index
    @artists = Artist.all_including_compilation
  end
end
