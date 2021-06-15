class Artist < ApplicationRecord
  include Comparable

  belongs_to :genre, optional: true
  has_many :albums

  using StringJpExt

  def <=>(other)
    sorter <=> other.sorter
  end

  def to_s
    name
  end

  protected

    def sorter
      (sort_name || name).downcase.to_hiragana
    end
end
