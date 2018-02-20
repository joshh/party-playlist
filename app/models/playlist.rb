# == Schema Information
#
# Table name: playlists
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  user_id     :integer
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string(255)
#

class Playlist < ActiveRecord::Base

  before_create :set_slug
  belongs_to :user
  has_many :playlist_tracks
  has_many :playlist_users

  scope :sorted, -> { order(created_at: :asc) }


  def tracks
    playlist_tracks
  end

  def can_add_uri? uri
    !tracks.collect{|t| t.uri}.include? uri
  end

  def add_participant user
    if user_id != user.id && !playlist_users.pluck(:user_id).include?(user.id)
      playlist_users.create(user_id: user.id)
    end
  end


  def set_slug
    charset = Array('A'..'Z') + Array('1'..'9') - ['O']
    self.slug = (0..5).collect{|x| charset[ rand(0..charset.length-1) ] }.join('')
  end


  def reload
    @playlist = Playlists.find(params[:id])
    @current_user = current_user
  end

  def add_track resp, current_user
    rec = playlist_tracks.new(
      name: resp[:name],
      album: resp[:album],
      album_uri: resp[:album_id],
      art: resp[:images].last['url'],
      user_id: current_user.id,
      artist: resp[:artist],
      artist_uri: resp[:artist_id],
      uri: resp[:id],
      length: resp[:length]
    )
    rec.save!
  end


end
