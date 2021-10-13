class Playlist < ApplicationRecord
  include BooleanMethodDefiner

  has_many :playlist_tracks, -> { order(:ordering) }, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
end
