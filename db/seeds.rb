def value_of(key, track)
  track.xpath("key[.='#{key}']").first&.next_element&.text
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

tracks.each do |track|
  genre_name = value_of('Genre', track)
  genre = genre_name && Genre.find_or_create_by!(name: genre_name)

  artist_name = value_of('Artist', track)
  next unless artist_name

  sort_name = value_of('Sort Artist', track)

  artist = Artist.find_or_create_by!(name: artist_name)
  artist.update!(genre: genre, sort_name: sort_name)
end
