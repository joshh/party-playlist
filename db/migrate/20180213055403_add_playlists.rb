class AddPlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :user_id
      t.string :slug
      t.timestamps
    end


    create_table :playlist_tracks do |t|
      t.string :name
      t.string :album
      t.string :art
      t.integer :user_id
      t.integer :sort_order
      t.timestamps
    end

  end
end
