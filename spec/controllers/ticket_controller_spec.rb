require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  context 'no authentication' do
    before { allow(controller).to receive(:authenticate_user!).and_return(true) }
    describe '#index' do
      before do
        get :index, as: :json
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a proper template' do
        expect(response).to render_template(:index)
      end
    end

    describe '#show' do
      before { get :show, params: { id: 2 }, as: :json }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'renders a proper template' do
        expect(response).to render_template(:show)
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
        it 'returns 201 status code' do
          expect(response).to have_http_status(:created)
        end
        it 'renders a proper template' do
          expect(response).to render_template(:show)
        end
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
        it 'returns 409 status code' do
          expect(response).to have_http_status(:conflict)
        end
        it 'returns proper response' do
          expect(response.parsed_body['error'])
            .to eq("Worker can\'t be unactive!")
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
        it 'returns 422 status code' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
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

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders a proper template' do
          expect(response).to render_template(:show)
        end
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

        it 'returns 422 status code' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns all errors' do
          expect(response.parsed_body.keys).to eq(%w[title])
        end
      end
    end

    describe '#destroy' do
      context 'when ticket can be deleted' do
        before do
          delete :destroy, params: { id: 1 }
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns proper response' do
          expect(response.parsed_body['message']).to eq('Ticket was deleted!')
        end
      end
    end

    describe '#change_state' do
      context 'when valid params are send' do
        before do
          put :change_state, params: { id: 1, ticket: { state: 'Done' },
                                       format: :json }
        end
        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
        it 'renders a proper template' do
          expect(response).to render_template(:show)
        end
      end
      context 'when invalid params are send' do
        before do
          put :change_state, params: { id: 1, ticket: { state: '' },
                                       format: :json }
        end
        it 'returns status code 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        it 'returns all errors' do
          expect(response.parsed_body.keys).to eq(%w[state])
        end
      end
    end
    describe '#change_worker' do
      context 'when valid params are send' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 2 },
                                        format: :json }
        end
        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
        it 'renders a proper template' do
          expect(response).to render_template(:show)
        end
      end
      context 'when worker does not exist' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 6 },
                                        format: :json }
        end
        it 'returns status code 404' do
          expect(response).to have_http_status(:not_found)
        end
        it 'returns all errors' do
          expect(response.parsed_body.keys).to eq(%w[error])
        end
      end
      context 'when worker is unactive' do
        before do
          put :change_worker, params: { id: 1, ticket: { worker_id: 4 },
                                        format: :json }
        end
        it 'returns status code 409' do
          expect(response).to have_http_status(:conflict)
        end

        it 'returns all errors' do
          expect(response.parsed_body.keys).to eq(%w[error])
        end
        it 'returns proper response' do
          expect(response.parsed_body['error']).to eq('Worker can\'t be unactive!')
        end
      end
    end
  end
  context 'with authentification' do
    describe '#index' do
      before { get :index, as: :json }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
