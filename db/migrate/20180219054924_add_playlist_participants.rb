class AddPlaylistParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_users do |t|
      t.integer :playlist_id
      t.integer :user_id
      t.timestamps
    end
  end
end
