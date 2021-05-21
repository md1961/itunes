def value_of(key, track)
  track.xpath("key[.='#{key}']").first&.next_element.yield_self { |value_element|
    if value_element.nil?
      nil
    else
      if %w[true false].include?(value_element.name)
        value_element.name == 'true'
      else
        value_element&.text
      end
    end
  }
end

def update_for_non_nil!(model, attr_name, value)
  return if value.nil?
  return if model.send(attr_name).present?
  model.update!("#{attr_name}" => value)
end


FILENAME = 'db/source/itunes_library.xml'

unless File.exist?(FILENAME)
  STDERR.puts "Cannot find file '#{FILENAME}'"
  exit
end

ApplicationRecord.transaction do
  Track .destroy_all
  Album .destroy_all
  Artist.destroy_all
  Genre .destroy_all
end

xml_doc = File.open(FILENAME) { |f| Nokogiri::XML::Document.parse(f) }
tracks_key = xml_doc   .xpath("/plist/dict/key[.='Tracks']").first
track_dict = tracks_key.xpath('following-sibling::dict'    ).first
tracks     = track_dict.xpath('dict')

n_tracks = tracks.size

tracks.each_with_index do |track, index|
  print "  Processing tracks...: #{index + 1}/#{n_tracks}\r"

  genre_name = value_of('Genre', track)
  genre = genre_name && Genre.find_or_create_by!(name: genre_name)

  artist = value_of('Artist', track).yield_self { |artist_name|
    if artist_name.nil?
      nil
    else
      sort_name = value_of('Sort Artist', track)
      Artist.find_or_create_by!(name: artist_name).tap { |artist|
        update_for_non_nil!(artist, :genre    , genre    )
        update_for_non_nil!(artist, :sort_name, sort_name)
      }
    end
  }

  album = value_of('Album', track).yield_self { |album_name|
    if album_name.nil?
      nil
    else
      disc_number    = value_of('Disc Number', track)
      num_discs      = value_of('Disc Count' , track)
      num_tracks     = value_of('Track Count', track)
      is_compilation = value_of('Compilation', track)
      Album.find_or_create_by!(name: album_name).tap { |album|
        update_for_non_nil!(album, :disc_number   , disc_number   )
        update_for_non_nil!(album, :num_discs     , num_discs     )
        update_for_non_nil!(album, :num_tracks    , num_tracks    )
        update_for_non_nil!(album, :is_compilation, is_compilation)
      }
    end
  }

  track_name = value_of('Name', track)
  next unless track_name
  # TODO: Album Artist:string  ===> Check discrepancy with 'Artist'!!
  Track.create!(
    name:         track_name,
    id:           value_of('Track ID'    , track),
    total_time:   value_of('Total Time'  , track),
    track_number: value_of('Track Number', track),
    year:         value_of('Year'        , track),
    artist:       artist,
    album:        album
  )
end

puts
