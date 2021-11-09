class CreateAlbumsLabelLookups < ActiveRecord::Migration[5.2]

  def change
    create_table :albums_label_lookups do |t|
      t.bigint :albums_pointer_id
      t.bigint :albums_label_id

      t.timestamps
    end

    add_foreign_key :albums_label_lookups, :albums_pointers
    add_foreign_key :albums_label_lookups, :albums_labels
  end
end
