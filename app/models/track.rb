class Track < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :album , optional: true
  has_one :track_rating

  def rating
    track_rating&.value_real
  end

  def rated?
    rating && rating > 0
  end
end
