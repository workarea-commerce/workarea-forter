Workarea::Admin::Engine.routes.draw do
  resources :orders, only: [] do
    member do
      get :forter
    end
  end
end
