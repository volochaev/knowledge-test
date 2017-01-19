# frozen_string_literal: true
# :nodoc:
class VoteService
  attr_reader :weighted_average

  def initialize(post, rating_value) # user
    raise ArgumentError, 'Unknown ID' unless post&.id
    raise ArgumentError, 'Wrong rating value' unless (1..5).cover?(rating_value.to_i)

    @post  = post
    @value = rating_value
  end

  def save
    result = @post.with_lock do
      ActiveRecord::Base.connection.execute(%[
        SELECT add_vote(#{@post.id}, #{@value});
      ])
    end

    @weighted_average = result.first['add_vote']
    self
  end
end
