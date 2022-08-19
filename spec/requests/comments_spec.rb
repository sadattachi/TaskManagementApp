require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Comments', type: :request do
  context 'with valid authentication' do
  end
  context 'without authentication' do
    context 'GET /tickets/1/comments' do
      before { get '/tickets/1/comments', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
    end

    context 'GET /tickets/1/comments/1' do
      before { get '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:show) }
    end

    context 'POST /tickets/1/comments' do
      before { post '/tickets/1/comments', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end

    context 'PUT /tickets/1/comments' do
      before { put '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end

    context 'DELETE /tickets/1/comments' do
      before { delete '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end
  end
end
