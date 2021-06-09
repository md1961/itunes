FactoryBot.define do
  factory :playlist_track do
    playlist { nil }
    track { nil }
    ordering { 1 }
  end
end
