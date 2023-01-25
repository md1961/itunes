class Albums::Label < ApplicationRecord
  has_many :albums_labelings, class_name: 'Albums::Labeling', foreign_key: 'albums_label_id'
  has_many :albums, through: :albums_labelings

  scope :all_for_action_index, -> { where("name NOT IN (?)", %w[CD LP]) }

  def <=>(other)
    self.ordering <=> other.ordering
  end

  def to_s
    name =~ /\A[A-Z]+\z/ ? name : name.titleize
  end
end
