# == Schema Information
#
# Table name: playlist_users
#
#  id          :integer          not null, primary key
#  playlist_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#




class PlaylistUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :playlist

end
