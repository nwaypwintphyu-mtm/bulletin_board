Rails.application.routes.draw do
  get "user/index"
  resources :posts
  # devise_for :users
  devise_for :users, controllers: { registrations: 'registrations' }
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


  devise_scope :user do
    post '/confirm_registration', to: 'registrations#confirm_registration', as: 'confirm_registration'
    post '/new_registration', to: 'registrations#create' , as: 'new_registration'
  end
  
end
