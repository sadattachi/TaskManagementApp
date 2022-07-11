require 'rails_helper'

RSpec.describe WorkersController, type: :controller do
  context 'no authentification' do
    before { allow(controller).to receive(:authenticate_user!).and_return(true) }
    describe '#index' do
      before { get :index, as: :json }

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
                 worker: { last_name: 'test',
                           first_name: 'test',
                           age: 18,
                           role: 'Developer',
                           active: false },
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

      context 'when invalid attributes are send' do
        before do
          post :create,
               params: {
                 worker: { last_name: 'longer than 20 characters',
                           first_name: 'longer than 20 characters',
                           age: 1,
                           role: '',
                           active: false },
                 format: :json
               }
        end

        it 'returns 422 status code' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns all errors' do
          expect(response.parsed_body.keys).to eq(%w[last_name first_name age role])
        end
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
                id: 2,
                worker: { last_name: 'longer than 20 characters',
                          first_name: 'longer than 20 characters',
                          age: 1,
                          role: '',
                          active: false },
                format: :json
              }
        end

        it 'returns 422 status code' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

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

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns proper response' do
          expect(response.parsed_body['message']).to eq('Worker was deleted!')
        end
      end

      context 'when worker can\'t be deleted' do
        before do
          delete :destroy, params: { id: 1 }
        end

        it 'returns status code 409' do
          expect(response).to have_http_status(:conflict)
        end

        it 'returns proper response' do
          expect(response.parsed_body['error']).to eq('Can\'t delete worker with tickets!')
        end
      end
    end

    describe '#activate' do
      before do
        put :activate, params: { id: 2 }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns proper response' do
        expect(response.parsed_body['message']).to eq('Worker is now active!')
      end
    end

    describe '#deactivate' do
      context 'when worker can be deactivated' do
        before do
          put :deactivate, params: { id: 3 }
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns proper response' do
          expect(response.parsed_body['message']).to eq('Worker is now inactive!')
        end
      end

      context 'when worker can\'t be deactivated' do
        before do
          put :deactivate, params: { id: 1 }
        end

        it 'returns status code 409' do
          expect(response).to have_http_status(:conflict)
        end

        it 'returns proper response' do
          expect(response.parsed_body['error'])
            .to eq('Can\'t deactivate worker with \'Pending\' or \'In progress\' tickets!')
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
