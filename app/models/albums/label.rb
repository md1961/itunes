class Albums::Label < ApplicationRecord
  has_many :albums_label_lookups, class_name: 'Albums::LabelLookup', foreign_key: 'albums_label_id'
  has_many :albums_pointers, through: :albums_label_lookups

  def albums
    albums_pointers.map(&:album)
  end

  def to_s
    name.titleize
  end
end
