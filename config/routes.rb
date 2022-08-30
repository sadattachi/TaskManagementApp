# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  resources :workers
  resources :tickets do
    resources :comments
  end
  put 'workers/:id/activate', to: 'workers#activate'
  put 'workers/:id/deactivate', to: 'workers#deactivate'
  put 'tickets/:id/change-state', to: 'tickets#change_state'
  put 'tickets/:id/change-worker', to: 'tickets#change_worker'

  put 'workers/:id/assign-admin', to: 'admins#assign_admin'
  put 'workers/:id/unassign-admin', to: 'admins#unassign_admin'
end
