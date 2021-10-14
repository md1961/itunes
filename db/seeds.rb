require 'activerecord-import'


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

e_tracks_key = xml_doc     .xpath("/plist/dict/key[.='Tracks']").first
e_track_dict = e_tracks_key.xpath('following-sibling::dict'    ).first
e_tracks     = e_track_dict.xpath('dict')

n_tracks = e_tracks.size

e_tracks.each_with_index do |e_track, index|
  print "  Processing tracks...: #{index + 1}/#{n_tracks}\r"

  genre_name = value_of('Genre', e_track)
  genre = genre_name && Genre.find_or_create_by!(name: genre_name)

  artist = value_of('Artist', e_track).yield_self { |artist_name|
    if artist_name.nil?
      nil
    else
      sort_name = value_of('Sort Artist', e_track)
      Artist.find_or_create_by!(name: artist_name).tap { |artist|
        update_for_non_nil!(artist, :genre    , genre    )
        update_for_non_nil!(artist, :sort_name, sort_name)
      }
    end
  }

  album = value_of('Album', e_track).yield_self { |album_name|
    if album_name.nil?
      nil
    else
      disc_number    = value_of('Disc Number', e_track)
      num_discs      = value_of('Disc Count' , e_track)
      num_tracks     = value_of('Track Count', e_track)
      is_compilation = value_of('Compilation', e_track)
      Album.find_or_create_by!(name: album_name).tap { |album|
        update_for_non_nil!(album, :disc_number   , disc_number   )
        update_for_non_nil!(album, :num_discs     , num_discs     )
        update_for_non_nil!(album, :num_tracks    , num_tracks    )
        update_for_non_nil!(album, :is_compilation, is_compilation)
        update_for_non_nil!(album, :artist        , artist        ) unless is_compilation
      }
    end
  }

  track_name = value_of('Name', e_track)
  next unless track_name
  # TODO: Album Artist:string  ===> Check discrepancy with 'Artist'!!
  Track.create!(
    name:         track_name,
    id:           value_of('Track ID'    , e_track),
    total_time:   value_of('Total Time'  , e_track),
    track_number: value_of('Track Number', e_track),
    year:         value_of('Year'        , e_track),
    artist:       artist,
    album:        album
  )
end

puts

e_playlists_key  = xml_doc         .xpath("/plist/dict/key[.='Playlists']").first
e_playlist_array = e_playlists_key .xpath('following-sibling::array'    )  .first
e_playlists      = e_playlist_array.xpath('dict')

n_playlists = e_playlists.size

PLAYLIST_NAMES_TO_SKIP = %w[ダウンロード済み ミュージック ライブラリ]

e_playlists.each_with_index do |e_playlist, index|
  print "  Processing playlists...: #{index + 1}/#{n_playlists}\r"

  name = value_of('Name', e_playlist)
  next if PLAYLIST_NAMES_TO_SKIP.include?(name)

  Playlist.create!(
    id:                   value_of('Playlist ID'           , e_playlist),
    name:                 name,
    persistent_id:        value_of('Playlist Persistent ID', e_playlist),
    parent_persistent_id: value_of('Parent Persistent ID'  , e_playlist),
    description:          value_of('Description'           , e_playlist),
    is_folder:            value_of('Folder'                , e_playlist) || false,
    is_smart_list:        value_of('Smart Info'            , e_playlist) || false,
    is_master:            value_of('Master'                , e_playlist) || false,
    is_visible:           value_of('Visible'               , e_playlist) || true ,
    is_all_items:         value_of('All Items'             , e_playlist) || false,
    distinguished_kind:   value_of('Distinguished Kind'    , e_playlist),
  ).tap { |playlist|
    e_playlist_tracks = e_playlist.xpath('array/dict')
    e_playlist_tracks_with_index = e_playlist_tracks.zip(1 .. e_playlist_tracks.size)
    playlist_tracks = e_playlist_tracks_with_index.map { |e_playlist_track, index|
      playlist.playlist_tracks.new(
        track_id: value_of('Track ID', e_playlist_track),
        ordering: index
      )
    }
    PlaylistTrack.import playlist_tracks
  }
end

puts
