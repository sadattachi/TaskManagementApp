# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Comments', type: :request do
  context 'with valid authentication' do
    before { sign_in User.first }

    context 'when GET /tickets/1/comments' do
      before { get '/tickets/1/comments', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
    end

    context 'when GET /tickets/1/comments/1' do
      before { get '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:show) }
    end

    context 'when POST /tickets/1/comments' do
      before do
        post '/tickets/1/comments',
             params: {
               comment: { worker_id: 2,
                          message: 'test comment',
                          reply_to_comment_id: nil },
               format: :json
             }
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(response).to render_template(:show) }
      it { expect(Comment.where(message: 'test comment').first.id).to eq(Comment.last.id) }
    end

    context 'when PUT /tickets/1/comments' do
      context 'when edited by author' do
        context 'when message is less than 6 hours old' do
          before do
            put '/tickets/1/comments/1',
                params: {
                  comment: { message: 'test comment' },
                  format: :json
                }
          end

          it { expect(response).to have_http_status(:ok) }
          it { expect(response).to render_template(:show) }
        end

        context 'when message is more than 6 hours old' do
          before do
            Comment.first.update(created_at: '2022-08-17 00:00:00')
            put '/tickets/1/comments/1',
                params: {
                  comment: { message: 'test comment' },
                  format: :json
                }
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq('Messages can only be edited for the first 6 hours!') }
        end
      end

      context 'when edited by other user' do
        before do
          put '/tickets/1/comments/2',
              params: {
                comment: { message: 'test comment' },
                format: :json
              }
        end

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq('Only author can edit this comment!') }
      end
    end

    context 'when DELETE /tickets/1/comments' do
      context 'when deleted by author' do
        context 'when message is less than hour old' do
          before { delete '/tickets/1/comments/1', as: :json }

          it { expect(response).to have_http_status(:ok) }
          it { expect(response.parsed_body['message']).to eq('Comment was deleted') }
        end

        context 'when message is more than hour old' do
          before do
            Comment.first.update(created_at: '2022-08-17 00:00:00')
            delete '/tickets/1/comments/1', as: :json
          end

          it { expect(response).to have_http_status(:forbidden) }
          it { expect(response.parsed_body['error']).to eq('Messages can only be deleted for the first hour!') }
        end
      end

      context 'when deleted by other user' do
        before { delete '/tickets/1/comments/2', as: :json }

        it { expect(response).to have_http_status(:forbidden) }
        it { expect(response.parsed_body['error']).to eq('Only author can delete this comment!') }
      end
    end
  end

  context 'without authentication' do
    context 'when GET /tickets/1/comments' do
      before { get '/tickets/1/comments', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
    end

    context 'when GET /tickets/1/comments/1' do
      before { get '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:show) }
    end

    context 'when POST /tickets/1/comments' do
      before { post '/tickets/1/comments', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end

    context 'when PUT /tickets/1/comments' do
      before { put '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end

    context 'when DELETE /tickets/1/comments' do
      before { delete '/tickets/1/comments/1', as: :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body['error']).to eq('You need to log in to continue!') }
    end
  end
end
