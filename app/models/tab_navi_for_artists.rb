class TabNaviForArtists
  attr_reader :all_initial_ranges, :current_initial_range

  def initialize(initial_range_name = nil)
    @all_initial_ranges = ArtistInitialRange.all
    @current_initial_range = if initial_range_name.nil?
                               @all_initial_ranges.first
                             else
                               @all_initial_ranges.detect { |initial_range|
                                 initial_range.name == initial_range_name
                               }
                             end
  end

  def current_artists
    current_initial_range.artists
  end
end
