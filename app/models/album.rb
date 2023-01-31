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

  def base_name
    name.sub(/(?:\s*[(\[][^(\[]+[)\]])+\z/, '')
  end

  def albums_in_set
    albums = artist&.albums || Album.compilations
    albums.where("name LIKE ?", "#{base_name}%").sort_by(&:name)
  end

  def subsequent?
    self != albums_in_set.first
  end

  def num_tracks_rated
    tracks.count(&:rated?)
  end

  def put_label(label)
    unless label.is_a?(Albums::Label)
      raise ArgumentError, "Argument must be an Albums::Label (#{label.class} given)"
    end
    return if labels.include?(label)
    labels << label
  end

  def remove_label(label)
    unless label.is_a?(Albums::Label)
      raise ArgumentError, "Argument must be an Albums::Label (#{label.class} given)"
    end
    return unless labels.include?(label)
    albums_labelings.find_by(label: label).destroy
  end

  def ==(other)
    artist == other&.artist && name == other&.name
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
        is_compilation ? Artist::COMPILATION : artist,
        is_compilation ? 0 : (year || 999999),
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
