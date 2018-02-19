class AddMissingInfoToTracks2 < ActiveRecord::Migration[5.1]
  def change
    add_column :playlist_tracks, :artist_uri, :string
    add_column :playlist_tracks, :album_uri, :string
  end
end
