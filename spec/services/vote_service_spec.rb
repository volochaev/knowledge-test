require 'spec_helper'

describe VoteService do
  let!(:post_service) { PostCreator.new(title: 'test', body: 'test', user: 'test', user_ip_address: '127.0.0.1').save }

  describe '#update!' do
    context 'validation of passed arguments' do
      it 'raises `ArgumentError` when post_id is invalid/not exists' do
        expect{ VoteService.new(Post.new, 2).save }.to raise_error(ArgumentError)
      end

      it 'raises `ArgumentError` when rating value is invalid' do
        expect{ VoteService.new(post_service.resource, 6).save }.to raise_error(ArgumentError)
      end
    end

    context 'average rating' do
      it 'return correct values' do
        VoteService.new(post_service.resource, 2).save
        expect(post_service.resource.reload.weighted_average).to eq(2)
        expect(post_service.resource.rating.two_stars_count).to eq(1)
        expect(post_service.resource.rating.votes_count).to eq(1)
      end

      it 'return correct value after multiply calls' do
        rates = 50.times.inject([]) { |m| m << rand(5) + 1 }
        rates.each { |i| VoteService.new(post_service.resource, i).save }
        expect(post_service.resource.reload.weighted_average).to eq(rates.inject{ |sum, el| sum + el }.to_f / rates.size)
      end
    end
  end
end
