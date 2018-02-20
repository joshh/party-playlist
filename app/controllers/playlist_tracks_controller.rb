class PlaylistTracksController < ApplicationController


  def play
    track = PlaylistTrack.find(params[:playlist_track_id])
    if current_user && track && track.playlist.user == current_user
      track.play_track
    end
    render plain: "OK"
  end

end