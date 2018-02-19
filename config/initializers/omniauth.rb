keys = Rails.application.secrets


Rails.application.config.middleware.use OmniAuth::Builder do
  scopes = [
    'playlist-read-private',
    'user-read-private',
    'user-read-email',
    'playlist-modify-public',
    'playlist-modify-private',
    'user-read-playback-state',
    'user-modify-playback-state',
    'user-read-recently-played'
  ]

  provider :spotify, ENV['SPOTIFY_ID'], ENV['SPOTIFY_SECRET'], scope: scopes.join(' ')
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
end

