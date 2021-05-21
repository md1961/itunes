def value_of(key, track)
  track.xpath("key[.='#{key}']").first&.next_element&.text
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

num_tracks = tracks.size

tracks.each_with_index do |track, index|
  print "  Processing tracks...: #{index + 1}/#{num_tracks}\r"

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
end

puts
