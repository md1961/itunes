FactoryBot.define do
  factory :albums_pointer, class: 'Albums::Pointer' do
    artist_name { "MyString" }
    album_name { "MyString" }
  end
end
