class Albums::Pointer < ApplicationRecord
  has_many :albums_label_lookups, class_name: 'Albums::LabelLookup', foreign_key: 'albums_pointer_id'
  has_many :albums_labels, through: :albums_label_lookups

  def album
    Album.find_by(artist: Artist.find_by(name: artist_name), name: album_name)
  end
end
