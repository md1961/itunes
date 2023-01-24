class Albums::Labeling < ApplicationRecord
  belongs_to :album
  belongs_to :label, class_name: 'Albums::Label', foreign_key: 'albums_label_id'
end
