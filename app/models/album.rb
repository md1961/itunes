class Album < ApplicationRecord
  include Comparable, BooleanMethodDefiner

  belongs_to :artist, optional: true
  has_many :tracks, -> { order(:track_number) }
  has_many :albums_labelings, class_name: 'Albums::Labeling'
  has_many :labels, through: :albums_labelings

  validates :name, presence: true, uniqueness: {scope: :artist}

  scope :compilations, -> { where(is_compilation: true) }

  def year
    tracks.pluck(:year).compact.max
  end

  def total_time
    tracks.pluck(:total_time).compact.sum
  end

  def albums_in_set
    basename = name.sub(/(?:\s*[(\[][^(\[]+[)\]])+\z/, '')
    albums = artist&.albums || Album.compilations
    albums.where("name LIKE ?", "#{basename}%").sort_by(&:name)
  end

  def num_tracks_rated
    tracks.count(&:rated?)
  end

  #def labels
  #  pointer&.albums_labels || []
  #end

  def put_label(label)
    unless label.is_a?(Albums::Label)
      raise ArgumentError, "Argument must be an Albums::Label (#{label.class} given)"
    end
    return if labels.include?(label)
    pointer_or_create.albums_label_lookups.create!(albums_label: label)
  end

  def remove_label(label)
    unless label.is_a?(Albums::Label)
      raise ArgumentError, "Argument must be an Albums::Label (#{label.class} given)"
    end
    return unless labels.include?(label)
    pointer_or_create.albums_label_lookups.find_by(albums_label: label).destroy
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

  private

    def pointer
      Albums::Pointer.find_by(artist_name: artist&.name, album_name: name)
    end

    def pointer_or_create
      Albums::Pointer.find_or_create_by!(artist_name: artist&.name, album_name: name)
    end

end
