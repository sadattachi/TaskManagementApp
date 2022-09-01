# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe WorkersController, type: :controller do
  context 'with valid authentication' do
    context 'when admin' do
      before do
        user = User.first
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
      end

      describe '#index' do
        before { get :index, as: :json }

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

      describe '#update' do
        context 'when valid attributes are send' do
          before do
            put :update,
                params: {
                  id: 2,
                  worker: { last_name: 'test',
                            first_name: 'test',
                            age: 18,
                            role: 'Developer',
                            active: false },
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
                  id: 2,
                  worker: { last_name: 'longer than 20 characters',
                            first_name: 'longer than 20 characters',
                            age: 1,
                            role: '',
                            active: false },
                  format: :json
                }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }

          it 'returns all errors' do
            expect(response.parsed_body.keys).to eq(%w[last_name first_name age role])
          end
        end
      end

      describe '#destroy' do
        context 'when worker can be deleted' do
          before do
            delete :destroy, params: { id: 4 }
          end

          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Worker was deleted!') }
        end

        context "when worker can't be deleted" do
          before do
            delete :destroy, params: { id: 1 }
          end

          it { expect(response).to have_http_status(:conflict) }
          it { expect(response.parsed_body['error']).to eq('Can\'t delete worker with tickets!') }
        end
      end

      describe '#activate' do
        before do
          put :activate, params: { id: 2 }
        end

        context 'when valid params' do
          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Worker is now active!') }
        end
      end

      describe '#deactivate' do
        context 'when worker can be deactivated' do
          before do
            put :deactivate, params: { id: 3 }
          end

          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Worker is now inactive!') }
        end

        context "when worker can't be deactivated" do
          before do
            put :deactivate, params: { id: 2 }
          end

          it { expect(response).to have_http_status(:conflict) }

          it do
            expect(response.parsed_body['error'])
              .to eq('Can\'t deactivate worker with \'Pending\' or \'In progress\' tickets!')
          end
        end
      end
    end

    context 'when manager' do
      before do
        user = User.all[2]
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
      end

      describe '#index' do
        before { get :index, as: :json }

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

      describe '#update' do
        context 'when valid attributes are send' do
          before do
            put :update,
                params: {
                  id: 2,
                  worker: { last_name: 'test',
                            first_name: 'test',
                            age: 18,
                            role: 'Developer',
                            active: false },
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
                  id: 2,
                  worker: { last_name: 'longer than 20 characters',
                            first_name: 'longer than 20 characters',
                            age: 1,
                            role: '',
                            active: false },
                  format: :json
                }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }

          it 'returns all errors' do
            expect(response.parsed_body.keys).to eq(%w[last_name first_name age role])
          end
        end
      end

      describe '#destroy' do
        context 'when worker can be deleted' do
          before do
            delete :destroy, params: { id: 4 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end

        context "when worker can't be deleted" do
          before do
            delete :destroy, params: { id: 1 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#activate' do
        before do
          put :activate, params: { id: 2 }
        end

        context 'when valid params' do
          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Worker is now active!') }
        end
      end

      describe '#deactivate' do
        context 'when worker can be deactivated' do
          before do
            put :deactivate, params: { id: 3 }
          end

          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Worker is now inactive!') }
        end

        context "when worker can't be deactivated" do
          before do
            put :deactivate, params: { id: 2 }
          end

          it { expect(response).to have_http_status(:conflict) }

          it do
            expect(response.parsed_body['error'])
              .to eq('Can\'t deactivate worker with \'Pending\' or \'In progress\' tickets!')
          end
        end
      end
    end

    context 'when developer' do
      before do
        user = User.all[1]
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
      end

      describe '#index' do
        before { get :index, as: :json }

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

      describe '#update' do
        context 'when self' do
          context 'when valid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 2,
                    worker: { last_name: 'test',
                              first_name: 'test',
                              age: 18,
                              role: 'Developer',
                              active: false },
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
                    id: 2,
                    worker: { last_name: 'longer than 20 characters',
                              first_name: 'longer than 20 characters',
                              age: 1,
                              role: '',
                              active: false },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:unprocessable_entity) }

            it 'returns all errors' do
              expect(response.parsed_body.keys).to eq(%w[last_name first_name age])
            end
          end
        end

        context 'when other worker' do
          context 'when valid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 1,
                    worker: { last_name: 'test',
                              first_name: 'test',
                              age: 18,
                              role: 'Developer',
                              active: false },
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
                    id: 1,
                    worker: { last_name: 'longer than 20 characters',
                              first_name: 'longer than 20 characters',
                              age: 1,
                              role: '',
                              active: false },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
        end
      end

      describe '#destroy' do
        context 'when worker can be deleted' do
          before do
            delete :destroy, params: { id: 4 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end

        context "when worker can't be deleted" do
          before do
            delete :destroy, params: { id: 1 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#activate' do
        before do
          put :activate, params: { id: 2 }
        end

        context 'when valid params' do
          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#deactivate' do
        context 'when worker can be deactivated' do
          before do
            put :deactivate, params: { id: 3 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end

        context "when worker can't be deactivated" do
          before do
            put :deactivate, params: { id: 2 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end
    end

    context 'when UI/UX Designer' do
      before do
        user = User.all[3]
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        request.headers.merge!(auth_headers)
      end

      describe '#index' do
        before { get :index, as: :json }

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

      describe '#update' do
        context 'when self' do
          context 'when valid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 4,
                    worker: { last_name: 'test',
                              first_name: 'test',
                              age: 18,
                              role: 'Developer',
                              active: false },
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
                    id: 4,
                    worker: { last_name: 'longer than 20 characters',
                              first_name: 'longer than 20 characters',
                              age: 1,
                              role: '',
                              active: false },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:unprocessable_entity) }

            it 'returns all errors' do
              expect(response.parsed_body.keys).to eq(%w[last_name first_name age])
            end
          end
        end

        context 'when other worker' do
          context 'when valid attributes are send' do
            before do
              put :update,
                  params: {
                    id: 1,
                    worker: { last_name: 'test',
                              first_name: 'test',
                              age: 18,
                              role: 'Developer',
                              active: false },
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
                    id: 1,
                    worker: { last_name: 'longer than 20 characters',
                              first_name: 'longer than 20 characters',
                              age: 1,
                              role: '',
                              active: false },
                    format: :json
                  }
            end

            it { expect(response).to have_http_status(:forbidden) }
            it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
          end
        end
      end

      describe '#destroy' do
        context 'when worker can be deleted' do
          before do
            delete :destroy, params: { id: 4 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end

        context "when worker can't be deleted" do
          before do
            delete :destroy, params: { id: 1 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#activate' do
        before do
          put :activate, params: { id: 2 }
        end

        context 'when valid params' do
          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end

      describe '#deactivate' do
        context 'when worker can be deactivated' do
          before do
            put :deactivate, params: { id: 3 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end

        context "when worker can't be deactivated" do
          before do
            put :deactivate, params: { id: 2 }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
        end
      end
    end

    context 'when deactivated' do
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
