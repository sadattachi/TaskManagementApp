# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe TicketsController, type: :controller do
  context 'with valid authentication' do
    context 'as admin' do
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
                             worker_id: 5,
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
          it 'returns all errors' do
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
            put :change_worker, params: { id: 1, ticket: { worker_id: 5 },
                                          format: :json }
          end

          it { expect(response).to have_http_status(:conflict) }
          it { expect(response.parsed_body.keys).to eq(%w[error]) }
          it { expect(response.parsed_body['error']).to eq("Worker can't be unactive!") }
        end
      end
    end
    context 'as manager' do
      before do
        user = User.all[2]
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
                             worker_id: 5,
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
          it 'returns all errors' do
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
            put :change_worker, params: { id: 1, ticket: { worker_id: 5 },
                                          format: :json }
          end

          it { expect(response).to have_http_status(:conflict) }
          it { expect(response.parsed_body.keys).to eq(%w[error]) }
          it { expect(response.parsed_body['error']).to eq("Worker can't be unactive!") }
        end
      end
    end
    context 'as developer' do
      before do
        user = User.all[1]
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
                             worker_id: 5,
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
          it 'returns all errors' do
            expect(response.parsed_body.keys)
              .to eq(%w[title state])
          end
        end
      end

      describe '#update' do
        context 'tickets created by this user' do
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
        context 'tickets created by another user' do
          context 'when valid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 2,
                    ticket: { title: 'edit',
                              description: 'edit',
                              worker_id: 1,
                              state: 'Done' },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end

          context 'when invalid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 2,
                    ticket: { title: 'title which has to be
                longer than 40 characters',
                              description: 'edit',
                              worker_id: 1,
                              state: '' },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
        end
      end

      describe '#destroy' do
        context 'when ticket can be deleted' do
          before { delete :destroy, params: { id: 1 } }

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#change_state' do
        context 'when assigned to this user' do
          context 'when valid params are send' do
            before do
              put :change_state, params: { id: 2,
                                           ticket: { state: 'Done' },
                                           format: :json }
            end

            it { expect(response).to have_http_status(:ok) }
            it { expect(response).to render_template(:show) }
          end

          context 'when invalid params are send' do
            before do
              put :change_state, params: { id: 2, ticket: { state: '' },
                                           format: :json }
            end

            it { expect(response).to have_http_status(:unprocessable_entity) }
            it { expect(response.parsed_body.keys).to eq(%w[state]) }
          end
        end
        context 'when assigned to another user' do
          context 'when valid params are send' do
            before do
              put :change_state, params: { id: 1,
                                           ticket: { state: 'Done' },
                                           format: :json }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end

          context 'when invalid params are send' do
            before do
              put :change_state, params: { id: 1, ticket: { state: '' },
                                           format: :json }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
        end
      end

      describe '#change_worker' do
        context 'when created by this user' do
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
              put :change_worker, params: { id: 1, ticket: { worker_id: 5 },
                                            format: :json }
            end

            it { expect(response).to have_http_status(:conflict) }
            it { expect(response.parsed_body.keys).to eq(%w[error]) }
            it { expect(response.parsed_body['error']).to eq("Worker can't be unactive!") }
          end
        end
        context 'when created by another user' do
          context 'when valid params are send' do
            before do
              put :change_worker, params: { id: 2, ticket: { worker_id: 2 },
                                            format: :json }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
          context 'when worker does not exist' do
            before do
              put :change_worker, params: { id: 2, ticket: { worker_id: 6 },
                                            format: :json }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
          context 'when worker is unactive' do
            before do
              put :change_worker, params: { id: 2, ticket: { worker_id: 5 },
                                            format: :json }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
        end
      end
    end
    context 'as deactivated' do
      before do
        user = User.all[4]
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
      end

      describe '#index' do
        before { get :index, as: :json }

        context 'when valid' do
          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("Deactivated users don't have access to any actions!") }
        end
      end
    end
  end
  context 'without authentification' do
    describe '#index' do
      before { get :index, as: :json }

      context 'when uauthorized' do
        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
  end
end
