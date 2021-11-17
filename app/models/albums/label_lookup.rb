class Albums::LabelLookup < ApplicationRecord
  belongs_to :albums_pointer, class_name: 'Albums::Pointer'
  belongs_to :albums_label  , class_name: 'Albums::Label'
end
