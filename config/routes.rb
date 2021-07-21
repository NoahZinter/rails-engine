Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/revenue/merchants', to: 'revenue#top_merchants'
      get '/merchants/find', to: 'merchants#search'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
      get '/items/find_all', to: 'items#search'
      resources :items do
        get '/merchant', to: 'item_merchant#show'
      end
    end
  end
end
