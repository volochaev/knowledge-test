require "rails_helper"

RSpec.describe PostsController, type: :controller do
  describe '#create' do
    let!(:request_params) do
      {
        post: {
          title: Faker::Hacker.say_something_smart,
          body: Faker::Lorem.paragraphs(rand(10..18)).join("\n"),
          user: Faker::Name.name,
          rating: rand(6)
        }
      }
    end

    let(:invalid_params) {
      hash = request_params.dup
      hash[:post].delete(:user)
      hash
    }

    context 'when resource params is valid' do
      before { post :create, params: request_params }

      it 'responds with 200' do
        expect(response.status).to eq(200)
      end

      it 'responds with json' do
        expect(response.content_type).to eq('application/json')
      end

      it 'shows the resource' do
        expect(response).to match_response_schema('post')
      end
    end

    context 'when resource params isn\'t valid' do
      it 'responds with 400 when no params was passed' do
        post :create, params: {}
        expect(response.status).to eq(400)
      end

      it 'responds with 422 when validation failed' do
        post :create, params: invalid_params
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body).keys).to contain_exactly 'message'
      end
    end
  end

  describe '#popular' do

  end
end
