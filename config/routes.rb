Berlin::Application.routes.draw do

  resource :mobile, only: [:edit, :update] do
    member do
      post 'send_verification_code'
    end
  end
  
  resource :profile, only: [:edit, :update]

  resources :cards, only: [:index, :new, :create, :show] do
    member do
      post 'charge'
    end
  end

  resources :orders, except: [:destroy] do
    member do
      post 'cancel'
    end
    resources :payments do
      member do
        get 'pay'
        post 'notify'
        get 'done'
      end
    end
  end

  resource :checkout, only: [:update]

  resource :cart, only: [:edit] do
    collection do
      post 'populate'
      post 'empty'
    end
    resources :line_items, only: [:update, :destroy]
  end

  resources :gyms, only: [:show] do
    member do
      post 'bookmark'
      post 'unbookmark'
    end

    collection do
      match :search
      get 'bookmarked'
    end

    resources :venues, only: [] do
      match :search, on: :collection
    end
  end

  namespace :admin do

    resources :companies

    resources :gym_groups

    resources :gyms do
      member do
        post 'confirm'
        post 'deny'
      end
      resources :gym_images, only: [:new, :create, :destroy]
    end

    match '/gym_session/:id' => 'gym_session#update', as: 'gym_session'

    # Dependent on current gym

    # resources :dashboard, only: [:index]

    resources :orders, except: [:new, :create] do
      member do
        post 'cancel'
        post 'check_in'
        get 'new_refund'
        post 'refund'
      end
      resources :payments do
        member do
          get 'pay'
          post 'notify'
          get 'done'
        end
      end
    end

    resource :cart do
      collection do
        post 'populate'
        put 'empty'
      end
      resources :line_items, only: [:update, :destroy]
    end

    resource :checkout, only: [:edit, :update]

    resources :venues, only: [:index] do
      collection do
        post 'publish'
      end
      resources :real_venues, only: [:index]
    end

    resources :activities do
      member do
        post 'enable'
        post 'disable'
      end
    end

    resources :venue_inventories, only: [] do
      collection do
        get 'edit_individual'
        put 'update_individual'
      end
    end

    resources :products, except: [:show]

    resources :cards do
      member do
        post 'charge'
      end
    end

    resources :card_types, except: [:show]
    
    resources :card_charges
    
    # Independence

    resources :users

    resources :cities, except: [:show]

    resources :areas, except: [:show]

    resources :venue_types, except: [:show]

    resources :payment_methods
    
  end

  match '/admin', to: 'admin/dashboard#index', as: :admin

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root to: 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
