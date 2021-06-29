class Artist < ApplicationRecord
  include Comparable

  belongs_to :genre, optional: true
  has_many :albums

  COMPILATION = Artist.new(name: 'Compilation')

  def self.all_including_compilation
    [Artist::COMPILATION] + Artist.all.sort
  end

  def <=>(other)
    sorter <=> other.sorter
  end

  def to_s
    name
  end

  protected

    using StringJpExt

    def sorter
      (sort_name || name).downcase.to_hiragana
    end
end
