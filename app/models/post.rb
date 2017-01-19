# frozen_string_literal: true
# :nodoc:
class Post < ApplicationRecord
  belongs_to :user
  has_one  :rating
  has_many :votes

  validates :title, :body, :rating, presence: true

  class << self
    def popular(limit = 10, offset = 0)
      order('weighted_average DESC').limit(limit).offset(offset)
    end

    def ip_with_users
      result = ActiveRecord::Base.connection.execute %[
        SELECT
          posts.author_ip,
          array_to_json(array_agg(DISTINCT(users.login))) AS users
        FROM "posts"
        JOIN users ON users.id = posts.user_id
        GROUP BY author_ip
      ]

      if result
        result.reduce([]) do |m, h|
          m << {
            ip: h['author_ip'],
            users: JSON.parse(h['users'])
          }
        end
      else
        []
      end
    end
  end

  def as_json(*)
    {
      id: id,
      title: title,
      body: body,
      rating: weighted_average,
      user: user&.login
    }
  end
end
