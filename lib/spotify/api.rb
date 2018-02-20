require 'net/http'
require 'uri'

module Spotify
  class API



    def initialize(user)
      @user = user
      refresh_token

      @path = "https://api.spotify.com/v1/"
    end

    def refresh_token
      if @user.oauth_expires_at < Time.now
        uri = URI.parse('https://accounts.spotify.com/api/token')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        base64 = Base64.strict_encode64(ENV['SPOTIFY_ID'] +':'+ ENV['SPOTIFY_SECRET'])
        header = {"Authorization": "Basic #{base64}"}
        req = Net::HTTP::Post.new(uri.request_uri, header)
        req.set_form_data({
          grant_type: 'refresh_token',
          refresh_token: @user.spotify_refresh_token
        })
        # req.body = payload.to_json

        res = http.request(req)
        json = JSON.parse(res.body)
        @user.update_attributes(oauth_token: json["access_token"], oauth_expires_at: Time.now+3600.seconds)
      end

    end

    def push(type, path, payload = nil)
      uri = URI.parse(path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      header = {"Authorization": "Bearer #{@user.oauth_token}"}
      if type == 'GET'
        if payload.nil?
          req = Net::HTTP::Get.new(uri.request_uri, header)
        else
          path2 = "#{uri.request_uri}?".concat(payload.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
          req = Net::HTTP::Get.new(path2, header)
        end
      elsif type == 'POST'
        req = Net::HTTP::Post.new(uri.request_uri, header)
        req.body = payload.to_json if payload
      elsif type == 'PUT'
        req = Net::HTTP::Put.new(uri.request_uri, header)
        req.body = payload.to_json if payload
      end

      res = http.request(req)
    end

    def me
      endpoint = @path + "me"
      resp = push('GET', endpoint)
      resp.body
    end

    def currently_playing
      endpoint = @path + "me/player"
      resp = push('GET', endpoint)
      resp.body
    end

    def previously_played
      endpoint = @path + "me/player/recently-played?limit=1"
      resp = push('GET', endpoint)
      resp.body
    end





    def track uri
      endpoint = @path + 'tracks/'+uri
      resp = push('GET', endpoint)
      resp.body
    end

    def new_playlist(playlist, public = false)
      payload = {
        "name": playlist.name,
        "description": "Playlist created by the Spotify Playlist app",
        "public": public
      }
      endpoint = @path + "users/#{playlist.user.uid}/playlists"
      resp = push('POST', endpoint, payload).body
    end

    def add_to_playlist(playlist, track_uris)
      endpoint = @path + "users/#{playlist.user.uid}/playlists/#{playlist.external_id}/tracks"

      endpoint = endpoint+'?uris=spotify:track:'+track_uris

      resp = push('POST', endpoint).body

    
    end

    def search(query, type)
      endpoint = @path + 'search'
      payload = {q: query, type: type, market: 'US'}
      puts payload
      resp = push('GET', endpoint, payload)
      puts resp.body
      service = JsonFormattingService.new(resp.body)
      @data = service.format_tracks if type == 'track'
    end










    def play
      endpoint = @path + "me/player/play"
      resp = push('PUT', endpoint)
      resp.body
    end


    def pause
      endpoint = @path + "me/player/pause"
      resp = push('PUT', endpoint)
      resp.body
    end

    def next
      endpoint = @path + "me/player/next"
      resp = push('POST', endpoint)
      resp.body
    end

    def prev
      endpoint = @path + "me/player/previous"
      resp = push('POST', endpoint)
      resp.body
    end

    def play_song(payload)
      endpoint = @path + "me/player/play"
      resp = push('PUT', endpoint, payload)
      resp.body
    end

  end
end

