Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :lists, only: %i() do
    collection do
      get :watched
      get :want_to_watch
      get :top_rated
    end
  end

  resources :movies, only: %i(show) do
    get :search, on: :collection
    get :discover, on: :collection
    post :rate

    post :toggle_want_to_watch
  end
end
