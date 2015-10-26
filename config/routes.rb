Rails.application.routes.draw do

   get 'groups/:id/posts', to: 'posts#index', as: 'home'

  resources :photos do
    member do
      get 'code_image'
    end
  end

  resources :notifications
  resources :relationships
  resources :followings
  resources :comments

  devise_for :users, :controllers => { :registrations => "users"}

  devise_scope :user do
    root to: "devise/sessions#new"
  end
  get 'search' => 'users#index'

  resources :users do

    resources :photos do
      member do
        get 'code_image'
      end
    end

    member do
      get :following, :followers
      get 'change_password'
      post 'update_password'
      post 'update_profile_picture'
      get 'admin/group_show'
    end
    collection do
      get 'admin/user_index'
      get 'admin/group_index'

    end
    resources :notifications
  end

  resources :groups do
    member do
      post 'send_mail_on_request'
    end
    resources :user_groups
    resources :posts do
      resources :comments do
        member do
          get 'new_child'
          post 'create_child'
        end
      end
    end
  end

  resources :user_groups do
    member do
      post 'add_group_user'
    end
  end

end
