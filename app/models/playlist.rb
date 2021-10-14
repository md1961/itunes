class Playlist < ApplicationRecord
  include BooleanMethodDefiner

  has_many :playlist_tracks, -> { order(:ordering) }, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  scope :non_folder, -> { where(is_folder: false) }

  def compilation?
    true
  end

  def to_s
    name
  end
end
