Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  resources :workers
  resources :tickets
  put 'workers/:id/activate', to: 'workers#activate'
  put 'workers/:id/deactivate', to: 'workers#deactivate'
  put 'tickets/:id/change-state', to: 'tickets#change_state'
  put 'tickets/:id/change-worker', to: 'tickets#change_worker'
end
