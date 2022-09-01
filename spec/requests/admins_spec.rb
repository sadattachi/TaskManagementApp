# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Admins', type: :request do
  context 'when admin' do
    before do
      sign_in User.first
    end

    describe 'when PUT workers/:id/assign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.parsed_body['message']).to eq('User is now admin') }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/2/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:conflict) }
        it { expect(response.parsed_body['message']).to eq('Only manager can be an admin') }
      end
    end

    describe 'when PUT workers/:id/unassign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.parsed_body['message']).to eq('User is no longer admin') }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/111/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.parsed_body['error']).to eq('User does not exist') }
      end
    end
  end

  context 'when other role' do
    before do
      sign_in User.all[1]
    end

    describe 'when PUT workers/:id/assign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/2/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
      end
    end

    describe 'when PUT workers/:id/unassign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/111/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("You don't have permission for this action!") }
      end
    end
  end

  context 'when deactivated' do
    before do
      sign_in User.last
    end

    describe 'when PUT workers/:id/assign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("Deactivated users don't have access to any actions!") }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/2/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("Deactivated users don't have access to any actions!") }
      end
    end

    describe 'when PUT workers/:id/unassign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("Deactivated users don't have access to any actions!") }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/111/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq("Deactivated users don't have access to any actions!") }
      end
    end
  end

  context 'when guest' do
    describe 'when PUT workers/:id/assign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/2/assign-admin', as: :json
        end

        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
      end
    end

    describe 'when PUT workers/:id/unassign-admin' do
      context 'when valid attributes' do
        before do
          put '/workers/3/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
      end

      context 'when invalid attributes' do
        before do
          put '/workers/111/unassign-admin', as: :json
        end

        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
      end
    end
  end
end
