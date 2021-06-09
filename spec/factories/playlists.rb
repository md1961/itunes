FactoryBot.define do
  factory :playlist do
    name { "MyString" }
    persistent_id { "MyString" }
    parent_persistent_id { "MyString" }
    description { "MyString" }
    is_folder { false }
    is_smart_list { false }
    is_master { false }
    is_visible { false }
    is_all_items { false }
    distinguished_kind { 1 }
  end
end
