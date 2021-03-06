# == Schema Information
#
# Table name: playlist_tracks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  album       :string(255)
#  art         :string(255)
#  user_id     :integer
#  sort_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  artist      :string(255)
#  playlist_id :integer
#  uri         :string(255)
#  length      :integer
#  artist_uri  :string(255)
#  album_uri   :string(255)
#

class PlaylistTrack < ActiveRecord::Base

  belongs_to :playlist
  before_create :set_sort
  after_create :maybe_play

  scope :sorted, -> { order(sort_order: :asc) }


  def set_sort
    if sort_order.nil?
      if playlist.tracks.count > 0
        x = playlist.tracks.sorted.last.sort_order + 1
      else
        x = 0
      end
      self.sort_order = x
    end
  end

  def minutes
    (length/1000/60).floor
  end

  def seconds
    length/1000%60
  end

  def previous_track
    playlist.tracks.where(sort_order: sort_order-1).try('first')
  end

  def play_track
    puts 'play track'
    api = Spotify::API.new(playlist.user)
    uri = "spotify:user:#{playlist.user.uid}:playlist:#{playlist.external_id}"
    payload = {"context_uri": uri, "offset": {"position": sort_order}}
    puts payload
    resp = api.play_song(payload)
    puts resp
  end

  def maybe_play
    puts 'maybe play'
    puts sort_order

    if sort_order == 0
      play_track
    else 
      currently = playlist.user.currently_playing
      puts 'currently'
      puts currently
      if currently == false || (currently[:is_playing] == false && currently[:id] == playlist.playlist_tracks.first.uri)
        previous = playlist.user.previously_played
        puts 'previous'
        puts previous
        puts previous[:context_id] == playlist.external_id
        puts previous[:id] == previous_track.uri
        if previous[:context_id] == playlist.external_id && previous[:id] == previous_track.uri
          play_track
        end
      end
    end
  end

end
