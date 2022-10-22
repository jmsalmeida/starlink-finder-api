Rails.application.routes.draw do
  resources :starlinks, path: 'starlinks', only: %i[index]
end
