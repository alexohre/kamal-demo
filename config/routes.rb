Rails.application.routes.draw do

  post 'send_email', to: 'pages#send_email', as: 'send_email'
  post '/send_sms', to: 'pages#send_sms', as: 'send_sms'

  get 'sms', to: 'pages#sms'
  get 'email', to: 'pages#email'
  resources :posts
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
