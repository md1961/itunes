class CreatePlaylists < ActiveRecord::Migration[5.2]

  def change
    create_table :playlists do |t|
      t.string  :name         , null: false
      t.string  :persistent_id
      t.string  :parent_persistent_id
      t.string  :description
      t.boolean :is_folder    , null: false, default: false
      t.boolean :is_smart_list, null: false, default: false
      t.boolean :is_master    , null: false, default: false
      t.boolean :is_visible   , null: false, default: true
      t.boolean :is_all_items , null: false, default: false
      t.integer :distinguished_kind

      t.timestamps
    end
  end
end
