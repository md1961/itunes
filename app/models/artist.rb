class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :albums

  def to_s
    name
  end
end
