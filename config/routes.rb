Rails.application.routes.draw do
  # always use www (makes the Auto0 stuff work a little better)
  unless Rails.env.development?
    constraints subdomain: false do
      get ':any', to: redirect(subdomain: 'www', path: '/%{any}'), any: /.*/
    end
  end

  resources :commitments, only: [:index, :show, :create, :destroy]
  resources :identities, only: [:index, :show, :update, :destroy]
  resources :users

  # auth0
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/signout' => 'auth0#sign_out'
  get '/auth/auth0/verify_email' => 'auth0#verify_email'
  get '/auth/auth0/password_reset' => 'auth0#password_reset'

  # static
  get '/*id' => 'pages#show', as: :page, format: false

  # root
  root 'pages#show', id: 'home'
end
