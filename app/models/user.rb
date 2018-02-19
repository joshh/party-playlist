# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  provider              :string(255)
#  uid                   :string(255)
#  name                  :string(255)
#  oauth_token           :string(255)
#  oauth_expires_at      :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  spotify_refresh_token :string(255)
#

class User < ActiveRecord::Base

  has_many :playlists
  has_many :playlist_users


  def refresh_token_if_expired

  end

  def can_create_playlists?
    provider == 'spotify'
  end

  def currently_playing
    api = Spotify::API.new(self)
    resp = api.currently_playing
    if resp.present?
      JsonFormattingService.new(resp).format_currently_playing
    else
      false
    end
  end

  def previously_played
    api = Spotify::API.new(self)
    resp = api.previously_played
    if resp
      JsonFormattingService.new(resp).format_previously_played
    else
      ''
    end
  end


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.spotify_refresh_token = auth.credentials.refresh_token if auth.provider == "spotify"
      user.save!
    end
  end
end
