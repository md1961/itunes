class CreateAlbumsLabelings < ActiveRecord::Migration[5.2]

  def change
    create_table :albums_labelings do |t|
      t.references :album       , foreign_key: true
      t.references :albums_label, foreign_key: true

      t.timestamps
    end
  end
end
