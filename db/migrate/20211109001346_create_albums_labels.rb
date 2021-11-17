class CreateAlbumsLabels < ActiveRecord::Migration[5.2]

  def change
    create_table :albums_labels do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :albums_labels, :name, unique: true
  end
end
