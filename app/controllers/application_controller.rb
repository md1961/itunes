class ApplicationController < ActionController::Base

  protected

    def prepare_artist_initial_ranges
      artist_initial_ranges = ArtistInitialRange.all
      initial_range = params[:initial_range].yield_self { |name|
        if name.nil?
          artist_initial_ranges.first
        else
          artist_initial_ranges.detect { |range|
            range.name == name
          }
        end
      }
      [artist_initial_ranges, initial_range]
    end
end
