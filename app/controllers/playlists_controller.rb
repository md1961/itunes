class PlaylistsController < ApplicationController

  def index
    @playlists = Playlist.eager_load(:tracks)
                         .non_folder
                         .reject { |playlist| playlist.tracks.size > 50 }
  end
end
