class AddMissingInfoToTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :playlist_tracks, :artist, :string
    add_column :playlist_tracks, :playlist_id, :integer
    add_column :playlist_tracks, :uri, :string
    add_column :playlist_tracks, :length, :integer
  end
end
