Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :lists, only: %i() do
    collection do
      get :watched
      get :want_to_watch
    end
  end

  resources :discoveries, only: %i(show)

  resources :movies, only: %i(show) do
    controller :ratings do
      post :rate, action: :rate
    end

    get :search, on: :collection

    controller :want_to_watches do
      post :toggle_want_to_watch, action: :toggle
    end

    controller :dont_want_to_watches do
      post :toggle_dont_want_to_watch, action: :toggle
    end
  end
end
