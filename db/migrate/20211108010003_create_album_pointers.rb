class CreateAlbumPointers < ActiveRecord::Migration[5.2]

  def change
    create_table :album_pointers do |t|
      t.string :artist_name
      t.string :album_name , null: false

      t.timestamps
    end
  end
end
