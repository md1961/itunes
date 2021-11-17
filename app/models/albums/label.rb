class Albums::Label < ApplicationRecord
  has_many :albums_label_lookups, class_name: 'Albums::LabelLookup', foreign_key: 'albums_label_id'
  has_many :albums_pointers, through: :albums_label_lookups
end
