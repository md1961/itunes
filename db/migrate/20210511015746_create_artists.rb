class CreateArtists < ActiveRecord::Migration[5.2]

  def change
    create_table :artists do |t|
      t.string     :name , null: false
      t.references :genre
      t.string     :sort_name

      t.timestamps
    end
  end
end
