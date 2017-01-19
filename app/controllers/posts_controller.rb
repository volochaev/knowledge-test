# frozen_string_literal: true
# :nodoc:
class PostsController < ApplicationController
  def create
    if params[:post]
      post = PostCreator.new(create_params).save

      if post.resource.persisted?
        render json: post.resource
      else
        render json: { message: post.resource.errors }, status: 422
      end
    else
      render json: { message: 'The request was improperly formatted' }, status: 400
    end
  end

  def popular
    render json: {
      posts: Post.popular(params[:limit] || 10, params[:offset] || 0).preload(:user)
    }
  end

  def ips
    render json: Post.ip_with_users
  end

  private

  def create_params
    post_params = params.require(:post)
    post_params = post_params.permit(:title, :body, :user, :user_ip_address, :rating).to_h
    post_params[:user_ip_address] ||= request.remote_ip
    post_params
  end
end
