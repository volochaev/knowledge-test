# frozen_string_literal: true
# :nodoc:
class PostCreator
  attr_reader :resource

  def initialize(request_params)
    prepare_data = ->(hash) { hash.each { |_, v| v&.strip! } }
    @params = prepare_data[request_params.dup || {}]
  end

  def save
    @resource = Post.new do |p|
      p.title     = @params[:title]
      p.body      = @params[:body]
      p.author_ip = @params[:user_ip_address]
      p.rating    = post_rating
      p.user      = post_author
      p.weighted_average = @params[:rating].to_i if post_rating.votes_count != 0
    end
    @resource.save
    self
  end

  def assign_rating!
    VoteService.new(@resource, @params[:rating])
  end

  private

  def post_author
    @post_author ||= User.find_or_create_by!(login: @params[:user])
  rescue ActiveRecord::RecordNotUnique
    retry
  rescue ActiveRecord::RecordInvalid
    @post_author = nil
  end

  def post_rating
    default_params = { votes_count: 1 }

    case @params[:rating].to_i
    when 1 then default_params[:one_star_count] = 1
    when 2 then default_params[:two_stars_count] = 1
    when 3 then default_params[:three_stars_count] = 1
    when 4 then default_params[:four_stars_count] = 1
    when 5 then default_params[:five_stars_count] = 1
    else default_params.delete(:votes_count)
    end

    Rating.new(default_params)
  end
end
