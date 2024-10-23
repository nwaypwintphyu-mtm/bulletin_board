Rails.application.routes.draw do
  get "user/index"
  resources :posts
  resources :users, only: [:create]
  # devise_for :users
  devise_for :users, controllers: { registrations: 'registrations' }

  # letter opener
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # devise_for :users, controllers: { sessions: "users/registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # get '/uploads/:filename', to: 'registrations#image', as: 'image'

  delete '/delete/user/:id', to: 'user#destroy', as: 'delete_user'
  root 'posts#index'

  # upload csv
  get '/upload/post', to: 'posts#upload_post', as: 'upload_post'
  post '/posts/upload_csv', to: 'posts#upload_csv'

  # download csv
  get '/posts/download/csv', to: 'posts#download_csv', as: 'download_posts_csv'

  #profile
  get '/user/profile', to: 'user#profile', as: 'user_profile'

  # edit profile back linkn

  get '/user/edit/profile', to: 'user#edit_profile', as: 'edit_profile'
  

  # change password
  get '/user/change/password', to: 'user#change_password', as: 'change_password'

  # edit profile
  # patch '/profile/update', to: 'user#update', as: 'user_edit'

  resources :user do
    member do
      get 'edit'
      patch 'update'
    end
  end
 





  devise_scope :user do
    # post '/confirm/registration', to: 'registrations#confirm_registration', as: 'confirm_registration'
    get '/users/sign_up', to: 'devise/registrations#new', as: 'new_user_registraion'
    post '/user/create', to: 'registrations#create', as: 'user_create'
    post '/confirm_registration', to: 'registrations#confirm_registration', as: 'confirm_registration'
  end
  
end
