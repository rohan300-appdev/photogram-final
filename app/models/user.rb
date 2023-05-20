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

  has_many :photos, class_name: "Photo", foreign_key: "owner_id"
end
