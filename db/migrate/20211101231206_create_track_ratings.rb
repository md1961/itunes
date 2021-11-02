class CreateTrackRatings < ActiveRecord::Migration[5.2]

  def change
    create_table :track_ratings do |t|
      t.references :track      , foreign_key: true
      t.integer    :value
      t.boolean    :is_computed, null: false, default: false

      t.timestamps
    end
  end
end
