Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tickets/filter', to: 'tickets#filter'
  resources :workers
  resources :tickets
  put 'workers/:id/activate', to: 'workers#activate'
  put 'workers/:id/deactivate', to: 'workers#deactivate'
  put 'tickets/:id/change-state', to: 'tickets#change_state'
  put 'tickets/:id/change-worker', to: 'tickets#change_worker'
end
