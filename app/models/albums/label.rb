class Albums::Label < ApplicationRecord
  has_many :albums_labelings, class_name: 'Albums::Labeling', foreign_key: 'albums_label_id'
  has_many :albums, through: :albums_labelings

  def to_s
    name.titleize
  end
end
