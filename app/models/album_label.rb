class AlbumLabel < ApplicationRecord
  validates :name, uniqueness: true
end
