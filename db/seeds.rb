def value_of(key, element)
  element.xpath("key[.='#{key}']").first&.next_element.yield_self { |value_element|
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
  PlaylistTrack.destroy_all
  Playlist     .destroy_all
  Track        .destroy_all
  Album        .destroy_all
  Artist       .destroy_all
  Genre        .destroy_all
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
        update_for_non_nil!(album, :artist        , artist        )
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

playlists_key  = xml_doc       .xpath("/plist/dict/key[.='Playlists']").first
playlist_array = playlists_key .xpath('following-sibling::array'    ).first
playlists      = playlist_array.xpath('dict')

n_playlists = playlists.size

PLAYLIST_NAMES_TO_SKIP = %w[ダウンロード済み ミュージック ライブラリ]

playlists.each_with_index do |playlist, index|
  print "  Processing playlists...: #{index + 1}/#{n_playlists}\r"

  name = value_of('Name', playlist)
  next if PLAYLIST_NAMES_TO_SKIP.include?(name)

  playlist_tracks = playlist.xpath('array/dict')

  Playlist.create!(
    id:                   value_of('Playlist ID'           , playlist),
    name:                 name,
    persistent_id:        value_of('Playlist Persistent ID', playlist),
    parent_persistent_id: value_of('Parent Persistent ID'  , playlist),
    description:          value_of('Description'           , playlist),
    is_folder:            value_of('Folder'                , playlist) || false,
    is_smart_list:        value_of('Smart Info'            , playlist) || false,
    is_master:            value_of('Master'                , playlist) || false,
    is_visible:           value_of('Visible'               , playlist) || true ,
    is_all_items:         value_of('All Items'             , playlist) || false,
    distinguished_kind:   value_of('Distinguished Kind'    , playlist),
  ).tap { |playlist|
    playlist_tracks.each.with_index(1) do |playlist_track, index|
      playlist.playlist_tracks.create!(
        track_id: value_of('Track ID', playlist_track),
        ordering: index
      )
    end
  }
end

puts
