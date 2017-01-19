require "rails_helper"

RSpec.describe VotesController, type: :controller do
  describe '#update' do
    context 'when post exists' do
      let!(:post) do
        PostCreator.new(title: 'test', body: 'test', user: 'test', user_ip_address: '127.0.0.1').save
      end
      before { patch :update, params: { id: post.resource.id, value: 4 } }

      it 'responds with 200' do
        expect(response.status).to eq(200)
      end

      it 'responds with json' do
        expect(response.content_type).to eq('application/json')
      end

      it 'responds with new rating value' do
        expect(JSON.parse(response.body)['rating']).to eq(4)
      end
    end

    context 'when post not exist' do
      before { patch :update, params: { id: 999, value: 4 } }

      it 'responds with 404' do
        expect(response.status).to eq(404)
      end

      it 'responds with json' do
        expect(response.content_type).to eq('application/json')
      end

      it 'responds with new rating value' do
        expect(JSON.parse(response.body).keys).to contain_exactly 'message'
      end
    end
  end
end
