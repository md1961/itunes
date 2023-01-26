class ArtistInitialRange

  MAX_NUM_ALBUMS_PER_RANGE = 120

  COMPILATION = new

  def self.all
    all_ranges = []
    range = new('a' .. 'a')
    until range.nil? do
      if range.last? || range.num_albums >= MAX_NUM_ALBUMS_PER_RANGE
        all_ranges << range
        range = range.next
      else
        range = range.expand
      end
    end

    [COMPILATION] + all_ranges + [new('あ' .. 'わ')]
  end

  def initialize(range)
    raise ArgumentError, "Argument must be a Range" unless range.is_a?(Range)

    first, last = range.yield_self { |r| [r.first, r.last] }.map(&:downcase)
    @range = first .. last
  end

  def last?
    @range.last == 'z'
  end

  def compilation?
    self == COMPILATION
  end

  def name
    compilation? ? 'Compilation' \
                 : @range.to_s.split('..').map(&:upcase).join('-')
  end

  def artists
    if compilation?
      return [Artist::COMPILATION]
    end

    range_exp = "[#{@range.first}-#{@range.last}]"
    re_name = /\A#{range_exp}/i
    Artist.all.find_all { |artist|
      artist.send(:sorter) =~ re_name && !artist.albums.empty?
    }
  end

  def num_albums
    artists.flat_map(&:albums).size
  end

  def expand
    return self if last?

    self.class.new(@range.first .. @range.last.succ)
  end

  def next
    return nil if last?

    @range.last.succ.yield_self { |c|
      self.class.new(c .. c)
    }
  end

  def to_s
    name
  end
end
