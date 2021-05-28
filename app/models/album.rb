class Album < ApplicationRecord
  belongs_to :artist, optional: true
  has_many :tracks, -> { order(:track_number) }
end
