class Track < ApplicationRecord
  belongs_to :artist_id
  belongs_to :album_id
end
