class CreateTracks < ActiveRecord::Migration[5.2]

  def change
    create_table :tracks do |t|
      t.string     :name        , null: false
      t.integer    :total_time
      t.integer    :track_number
      t.integer    :year
      t.references :artist, foreign_key: true
      t.references :album , foreign_key: true

      t.timestamps
    end
  end
end
