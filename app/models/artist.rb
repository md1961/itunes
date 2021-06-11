class Artist < ApplicationRecord
  include Comparable

  belongs_to :genre, optional: true
  has_many :albums

  using StringJpExt

  def sort_name
    (super || name).downcase.to_hiragana
  end

  def <=>(other)
    sort_name <=> other.sort_name
  end

  def to_s
    name
  end
end
