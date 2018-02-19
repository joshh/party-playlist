Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get  '/', to: 'home#index'
  post '/search', to: 'search#query'



  get '/auth/:provider/callback', to: 'sessions#create'


  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]


  resources :playlists, only: [:index, :show, :new, :create] do
    get 'track/:uri', to: 'playlists#add_track', as: 'add_track'

  end

  scope '/api' do
    # get '/current_track', to: 'api#current_track'

    # get '/search'

    # get '/add_playlist',
    # get '/add_to_playlist',
    # get '/remove_from_playlist',
  end
end
