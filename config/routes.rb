Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do

      namespace :storefront do
        resources :wholesalers, only: [:show, :index]
      end
    end
  end
end
