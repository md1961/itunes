class TrackRating < ApplicationRecord
  belongs_to :track

  def value_real
    is_computed ? nil : value
  end
end
