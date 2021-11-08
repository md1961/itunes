class AlbumPointer < ApplicationRecord
  has_many :album_label_lookups
  has_many :album_labels, through: :album_label_lookups
end
