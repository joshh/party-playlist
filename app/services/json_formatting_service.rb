class JsonFormattingService

  def initialize(raw_json)
    @json = JSON.parse(raw_json)
  end

  def format_tracks
    @json["tracks"]["items"].collect do |r|
      format_track(r)
    end
  end

  def format_single_track
    format_track @json
  end

  def format_track r
    {
      id: r['id'],
      name: r['name'],
      artist: r['artists'].first['name'],
      artist_id: r['artists'].first['id'],
      album: r['album']['name'],
      album_id: r['album']['id'],
      images: r['album']['images'],
      length: r['duration_ms']
    }
  end




  def format_previously_played
    format_playing_track(@json['items'].last)
  end

  def format_currently_playing
    format_playing_track @json
  end


  def format_playing_track json
    pp json

    if json["track"]
      track_id = json["track"]["id"]
    elsif json["item"]
      track_id = json["item"]["id"]
    else
      track_id = ""
    end

    data = {
      timestamp: json["timestamp"],
      progress_ms: json["progress_ms"],
      is_playing: json["is_playing"],
      id: track_id 
    }

    if !json['context'].nil?
      data[:context_type] = json["context"]["type"]
      data[:context_id] = json["context"]["uri"].split(':').last
    else
      data[:context_type] = nil
      data[:context_id] = nil
    end

    data

  end

end