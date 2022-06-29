require 'rails_helper'

RSpec.describe WorkersController do
  describe '#index' do
    it 'returns a success status code' do
      get '/workers.json'
      expect(response).to have_http_status(:ok)
    end

    it 'returns a proper JSON' do
      get '/workers.json'
      body = JSON.parse(response.body)
      expect(body).to eq(
        [{
          'name' => 'test last name test name',
          'age' => 20,
          'role' => 'Developer',
          'tickets_count' => 0
        }]
      )
    end
  end

  describe '#show' do
    it 'returns a success status code' do
      get '/workers/2.json'
      expect(response).to have_http_status(:ok)
    end
    it 'returns a proper JSON' do
      get '/workers/2.json'
      body = JSON.parse(response.body)
      expect(body).to eq(
        {
          'name' => 'test last name test name',
          'age' => 20,
          'role' => 'Developer',
          'tickets' => []
        }
      )
    end
  end
end
