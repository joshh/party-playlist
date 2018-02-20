Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get  '/', to: 'home#index'
  post '/search', to: 'search#query'





  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]


  resources :playlists, only: [:index, :show, :new, :create] do
    get 'track/:uri', to: 'playlists#add_track', as: 'add_track'
  end

  resources :playlist_tracks, only: [] do
    get 'play', to: 'playlist_tracks#play', as: 'play'
  end

  resources :users, only: [] do



  end


  get '/user/play', to: 'users#play', as: 'play'
  get '/user/pause', to: 'users#pause', as: 'pause'
  get '/user/prev', to: 'users#prev', as: 'previous'
  get '/user/next', to: 'users#next', as: 'next'


  scope '/api' do
    # get '/current_track', to: 'api#current_track'

    # get '/search'

    # get '/add_playlist',
    # get '/add_to_playlist',
    # get '/remove_from_playlist',
  end
end
