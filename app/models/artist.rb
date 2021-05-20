class Artist < ApplicationRecord
  belongs_to :genre, optional: true
end
