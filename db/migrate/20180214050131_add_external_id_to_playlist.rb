class AddExternalIdToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :external_id, :string
  end
end
