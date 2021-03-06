Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  post :upvote, to: 'votes#upvote'
  post :downvote, to: 'votes#downvote'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :topics, except: [:show] do
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end
end
