Rails.application.routes.draw do
  get 'starlinks/closest-satellites', to: 'starlinks#closest_satellites'
end
