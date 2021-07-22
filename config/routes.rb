Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :revenue do
        get '/merchants', to: 'revenue_merchants#top_merchants'
        get '/merchants/:id', to: 'revenue_merchants#revenue_show'
        get '/items', to: 'revenue_items#top_items'
        get '/unshipped', to: 'invoices#unshipped'
      end
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
0