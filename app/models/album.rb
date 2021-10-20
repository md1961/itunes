class Album < ApplicationRecord
  include Comparable, BooleanMethodDefiner

  belongs_to :artist, optional: true
  has_many :tracks, -> { order(:track_number) }

  scope :compilations, -> { where(is_compilation: true) }

  def year
    tracks.pluck(:year).compact.max
  end

  def albums_in_set
    basename = name.sub(/(?:\s*[(\[][^(\[]+[)\]])+\z/, '')
    albums = artist&.albums || Album.compilations
    albums.where("name LIKE ?", "#{basename}%").sort_by(&:name)
  end

  def <=>(other)
    sorter <=> other.sorter
  end

  def to_s
    name
  end

  protected

    def sorter
      [
        is_compilation ? -999999
                       : year || 999999,
        name.sub(/\Athe /i, '')
      ]
    end
end
