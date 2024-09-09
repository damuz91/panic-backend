Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'user/:id' => 'admin#user', as: 'user'
  get 'request_details/:id' => 'admin#request_details', as: 'request_details'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post 'send_sos' => 'messages#send_sos'
  post 'send_test' => 'messages#send_test'
end
