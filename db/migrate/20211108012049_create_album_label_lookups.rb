class CreateAlbumLabelLookups < ActiveRecord::Migration[5.2]

  def change
    create_table :album_label_lookups do |t|
      t.references :album_pointer, foreign_key: true
      t.references :album_label  , foreign_key: true

      t.timestamps
    end
  end
end
