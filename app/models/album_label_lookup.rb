class AlbumLabelLookup < ApplicationRecord
  belongs_to :album_pointer
  belongs_to :album_label
end
