class PlaylistsController < ApplicationController

  def index
    @my_ids = Playlist.where(user_id: current_user.id).pluck(:id)
    @part_ids = PlaylistUser.where(user_id: current_user.id).pluck(:playlist_id)
    @playlists = Playlist.where(id: @my_ids+@part_ids).sorted
  end

  def show
    @playlist = Playlist.find_by_slug(params[:id])
    @playlist.add_participant(current_user)
  end

  def new
    @playlist = Playlist.new
  end

  def create
    playlist = current_user.playlists.new(name: params[:playlist][:name])
    api = Spotify::API.new(current_user)
    resp = api.new_playlist(playlist)
    obj = JSON.parse(resp)

    if obj['id']
      playlist.external_id = obj['id']
      playlist.save
      redirect_to playlist_path(playlist.slug)
      return
    else
      flash[:error] = 'There was an error creating this playlist.'
      redirect_to new_playlist_path
    end
  end


  def add_track
    @playlist = Playlist.find_by_slug(params[:playlist_id])
    if @playlist.can_add_uri? params[:uri]
      api = Spotify::API.new(@playlist.user)
      resp = api.add_to_playlist(@playlist, params[:uri])

      if resp["snapshot_id"]
        track_resp = api.track(params[:uri])
        track_json = JsonFormattingService.new(track_resp).format_single_track
        @playlist.add_track(track_json, current_user)
      end
    else
      puts 'ALREADY ADDED'
    end
  end

end