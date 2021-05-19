class CreateAlbums < ActiveRecord::Migration[5.2]

  def change
    create_table :albums do |t|
      t.string  :name          , null: false
      t.integer :disc_number
      t.integer :num_discs
      t.integer :num_tracks
      t.boolean :is_compilation, null: false, default: false

      t.timestamps
    end
  end
end
