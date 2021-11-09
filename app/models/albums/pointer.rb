class Albums::Pointer < ApplicationRecord
  has_many :albums_label_lookups, class_name: 'Albums::LabelLookup', foreign_key: 'albums_pointer_id'
  has_many :albums_labels, through: :albums_label_lookups
end
