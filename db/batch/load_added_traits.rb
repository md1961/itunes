#! bin/rails runner

DATA_FILENAME = 'db/data/traits_added.yml'

unless File.exists?(DATA_FILENAME)
  STDERR.puts "Cannot find file '#{DATA_FILENAME}'"
  exit
end

data = YAML.load_file(DATA_FILENAME)
# data is: Array of [artist_name, album_name, [label#name, ...]]

data.flat_map { |item| item.last }.uniq.each do |label_name|
  unless Albums::Label.exists?(name: label_name)
    STDERR.puts "Cannot find Albums::Label '#{label_name}'"
    exit
  end
end

ApplicationRecord.transaction do
  data.each do |artist_name, album_name, label_names|
    artist = Artist.find_by(name: artist_name)
    unless artist
      STDERR.puts "Cannot find Artist '#{artist_name}'"
      exit
    end

    album = artist.albums.find_by(name: album_name)
    unless album
      STDERR.puts "Cannot find Album '#{album_name}' of '#{artist_name}'"
      exit
    end

    label_names.map { |name| Albums::Label.find_by(name: name) }.each do |label|
      album.put_label(label)
    end
  end
end
