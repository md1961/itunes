class CreateTracks < ActiveRecord::Migration[5.2]

  def change
    create_table :tracks do |t|
      t.string     :name        , null: false
      t.integer    :total_time
      t.integer    :track_number
      t.integer    :year
      t.references :artist_id, foreign_key: true
      t.references :album_id , foreign_key: true

      t.timestamps
    end
  end
end
