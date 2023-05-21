# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true

  validates :username, :uniqueness => {:case_sensitive => false}
  validates :username, :presence => true

  has_secure_password

  has_many :followers, class_name: 'FollowRequest', foreign_key: 'recipient_id'

  has_many :is_following, class_name: 'FollowRequest', foreign_key: 'sender_id'

  def all_followers
    return self.followers.where({:status => "accepted"})
  end

  def all_is_following
    return self.is_following.where({:status => "accepted"})
  end

  has_many :is_following_check, -> {where(status: "accepted")}, class_name: 'FollowRequest', foreign_key: 'sender_id'

  has_many :followers_pending, -> {where(status: "pending")}, class_name: 'FollowRequest', foreign_key: 'recipient_id'

  has_many :photos, class_name: "Photo", foreign_key: "owner_id"

  has_many :is_following_users, through: :is_following_check, source: :followed_by

  has_many :following_photos, through: :is_following_users, source: :photos

end
