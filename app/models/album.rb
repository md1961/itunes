class Album < ApplicationRecord
  has_many :tracks, -> { order(:track_number) }
end
