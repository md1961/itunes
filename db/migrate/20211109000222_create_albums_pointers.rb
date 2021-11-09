class CreateAlbumsPointers < ActiveRecord::Migration[5.2]

  def change
    create_table :albums_pointers do |t|
      t.string :artist_name
      t.string :album_name , null: false

      t.timestamps
    end
  end
end