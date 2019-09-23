Rails.application.routes.draw do
  root to: "dashboard#index"

  resources :movies
  resources :people
end
