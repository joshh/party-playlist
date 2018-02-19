class SearchController < ApplicationController

  def query
    @playlist = Playlist.find_by_slug(params['id'])
    puts 'pls'
    puts @playlist.id
    api = Spotify::API.new(@playlist.user)
    puts 'DO QUERY'
    resp = api.search(params['query'], params['commit'])
    puts 'QUERY'
    puts resp
    @data = resp
  end




  def show_album
  end


end