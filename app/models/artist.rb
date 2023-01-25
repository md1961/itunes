class Artist < ApplicationRecord
  include Comparable

  belongs_to :genre, optional: true
  has_many :albums

  COMPILATION = Artist.new(name: 'Compilation')

  def COMPILATION.albums
    Album.where(artist: nil)
  end

  def self.all_including_compilation
    [COMPILATION] + Artist.eager_load(albums: {tracks: :track_rating}).sort
  end

  def compilation?
    self == COMPILATION
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
      compilation? ? '____' : (sort_name || name).downcase.to_hiragana
    end
end
