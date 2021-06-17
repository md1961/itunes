class Album < ApplicationRecord
  include Comparable

  belongs_to :artist, optional: true
  has_many :tracks, -> { order(:track_number) }

  scope :compilations, -> { where(is_compilation: true) }

  def year
    tracks.pluck(:year).compact.max
  end

  def <=>(other)
    sorter <=> other.sorter
  end

  protected

    def sorter
      [year || 999999, name]
    end
end
