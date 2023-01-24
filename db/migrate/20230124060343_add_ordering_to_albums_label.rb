class AddOrderingToAlbumsLabel < ActiveRecord::Migration[5.2]

  def change
    add_column :albums_labels, :ordering, :integer
    add_index  :albums_labels, :ordering, unique: true
  end
end
