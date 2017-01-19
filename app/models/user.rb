# frozen_string_literal: true
# :nodoc:
class User < ApplicationRecord
  has_many :posts
  has_many :votes
  validates :login, presence: true

  def voted_for?(post)
    # TODO: check vote persistence for specified user.name and post.id
    # votes.where(post: post.id).exists?
  end
end
