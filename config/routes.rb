Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root controller: 'sessions', action: 'new'
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :dashboard, only: :index
    resources :users
    resources :orders do
      get :arrears, on: :collection

      put :hold, on: :member
      put :release, on: :member

      get :update_status, on: :collection
      put :update_status, on: :collection

      get :update_guide, on: :collection
      put :update_guide, on: :collection

      resources :notes, only: :create
    end
  end

  match '*path', via: :all, to: 'application#render_404'
end
