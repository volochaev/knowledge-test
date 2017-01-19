# frozen_string_literal: true
# :nodoc:
class VotesController < ApplicationController
  before_action :find_post, only: :update

  def update
    resource = VoteService.new(@post, vote_params['value']).save
    render json: { rating: resource.weighted_average.round(2) }
  rescue ArgumentError => e
    render json: { message: e.message }, status: 400
  end

  private

  def find_post
    @post = Post.find(vote_params['id'])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Unknown ID' }, status: 404
  end

  def vote_params
    @vote_params ||= params.permit(:id, :value)
  end
end
