FactoryBot.define do
  factory :albums_labeling, class: 'Albums::Labeling' do
    album { nil }
    albums_label { nil }
  end
end
