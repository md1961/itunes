FactoryBot.define do
  factory :albums_label_lookup, class: 'Albums::LabelLookup' do
    albums_pointer_id { "" }
    albums_label_id { "" }
  end
end
