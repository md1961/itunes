class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :albums
end
