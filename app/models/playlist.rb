class Playlist < ApplicationRecord
  include BooleanMethodDefiner

  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
end
