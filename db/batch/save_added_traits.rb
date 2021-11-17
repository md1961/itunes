#! bin/rails runner

puts YAML.dump(
  Albums::Pointer.includes(:albums_labels).map { |p|
    labels = p.albums_labels
    next if labels.empty?
    [p.artist_name, p.album_name, labels.map(&:name)]
  }.compact
)
