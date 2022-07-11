Rails.application.routes.draw do
  devise_for :users
  resources :workers
  resources :tickets
  put 'workers/:id/activate', to: 'workers#activate'
  put 'workers/:id/deactivate', to: 'workers#deactivate'
  put 'tickets/:id/change-state', to: 'tickets#change_state'
  put 'tickets/:id/change-worker', to: 'tickets#change_worker'
  # resources :workers, defaults: { format: :json }
  # resources :tickets, defaults: { format: :json }
  # put 'workers/:id/activate', to: 'workers#activate', defaults: { format: :json }
  # put 'workers/:id/deactivate', to: 'workers#deactivate', defaults: { format: :json }
  # put 'tickets/:id/change-state', to: 'tickets#change_state', defaults: { format: :json }
  # put 'tickets/:id/change-worker', to: 'tickets#change_worker', defaults: { format: :json }
end
