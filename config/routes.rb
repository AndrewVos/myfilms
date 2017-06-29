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

  resources :movies, only: %i() do
    controller :ratings do
      post :rate, action: :rate
    end

    controller :want_to_watches do
      post :toggle_want_to_watch, action: :toggle
    end
  end
end
