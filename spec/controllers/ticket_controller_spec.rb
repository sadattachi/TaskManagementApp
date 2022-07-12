require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe TicketsController, type: :controller do
  context 'with valid authentication' do
    before do
      user = User.first
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      request.headers.merge!(auth_headers)
    end

    describe '#index' do
      before do
        get :index, as: :json
      end

      context 'when valid' do
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:index) }
      end
    end

    describe '#show' do
      before { get :show, params: { id: 2 }, as: :json }

      context 'when valid params' do
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:show) }
      end
    end

    describe '#create' do
      context 'when valid attributes are send' do
        before do
          post :create,
               params: {
                 ticket: { title: 'test',
                           description: 'test',
                           worker_id: 1,
                           state: 'Done' },
                 format: :json
               }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response).to render_template(:show) }
      end

      context 'when ticket worker is unactive' do
        before do
          post :create,
               params: {
                 ticket: { title: 'test',
                           description: 'test',
                           worker_id: 4,
                           state: '' },
                 format: :json
               }
        end

        it { expect(response).to have_http_status(:conflict) }
        it do
          expect(response.parsed_body['error'])
            .to eq("Worker can't be unactive!")
        end
      end

      context 'when invalid attributes are send' do
        before do
          post :create,
               params: {
                 ticket: { title: 'title which has to be
                longer than 40 characters',
                           description: 'test',
                           worker_id: 1,
                           state: '' },
                 format: :json
               }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it do
          expect(response.parsed_body.keys)
            .to eq(%w[title state])
        end
      end
    end

    describe '#update' do
      context 'when valid attributes are send' do
        before do
          put :update,
              params: {
                id: 1,
                ticket: { title: 'edit',
                          description: 'edit',
                          worker_id: 1,
                          state: 'Done' },
                format: :json
              }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:show) }
      end

      context 'when invalid attributes are send' do
        before do
          put :update,
              params: {
                id: 1,
                ticket: { title: 'title which has to be
                longer than 40 characters',
                          description: 'edit',
                          worker_id: 1,
                          state: '' },
                format: :json
              }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body.keys).to eq(%w[title]) }
      end
    end

    describe '#destroy' do
      context 'when ticket can be deleted' do
        before { delete :destroy, params: { id: 1 } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.parsed_body['message']).to eq('Ticket was deleted!') }
      end
    end

    describe '#change_state' do
      context 'when valid params are send' do
        before do
          put :change_state, params: { id: 1,
                                       ticket: { state: 'Done' },
                                       format: :json }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:show) }
      end

      context 'when invalid params are send' do
        before do
          put :change_state, params: { id: 1, ticket: { state: '' },
                                       format: :json }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body.keys).to eq(%w[state]) }
      end
    end
    describe '#change_worker' do
      context 'when valid params are send' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 2 },
                                        format: :json }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:show) }
      end
      context 'when worker does not exist' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 6 },
                                        format: :json }
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.parsed_body.keys).to eq(%w[error]) }
      end
      context 'when worker is unactive' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 4 },
                                        format: :json }
        end

        it { expect(response).to have_http_status(:conflict) }
        it { expect(response.parsed_body.keys).to eq(%w[error]) }
        it { expect(response.parsed_body['error']).to eq("Worker can't be unactive!") }
      end
    end
  end
  context 'without authentification' do
    describe '#index' do
      before { get :index, as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
