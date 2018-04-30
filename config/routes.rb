Qiwicoin::Application.routes.draw do

  root to: "informations#welcome_qiwicoin"

  get 'download_client' => 'download_client#download'

  get 'terms_of_use' => "informations#terms_of_use"
  get 'contact_us' => "informations#contact_us"
  get 'bonuses' => "informations#bonuses"
  post 'send_message_to_admin' => "informations#contact_us"

  devise_for :users, :controllers => {:registrations => "devise_registrations", :sessions => "devise_sessions", :passwords => "devise_passwords"}
  
  devise_scope :user do
    get 'users/sign_up/:invitation_token', :to => 'devise_registrations#new'
  end

  get 'start' => "informations#start"

  get 'blockchain' => "informations#welcome"  
  scope '/blockchain' do

    get '/address/:id', to: 'addresses#show', as: :address_detail

    get '/block/:block_height', to: 'blocks#show', as: :block_detail

    post '/search/srch_condition', to: 'search#search', as: :search

    get '/tx/:id', to: 'transactions#show', as: :tx_detail

    post '/get_tx', to: 'informations#get_transactions', as: :home_tx

  end

  resource :profile, only: :show do
    collection do
      get  'referral', to: 'profiles#referral'
      post 'send-sms', to: 'profiles#send_sms', as: :send_sms
      post 'sms-verification', to: 'profiles#sms_verification', as: :sms_verification
      post 'qiwicoin-address', to: 'profiles#qiwicoin_address', as: :qiwicoin_address
    end
  end

  resources :auth, :controller => :sessions, :as => :auth do
    member do
      get :confirm, :resend
      patch :validate
    end
    collection do
      get :track
      delete :finish
      put :two_factor
    end
  end

  namespace :admin do

    resources :accounts do
      as_routes
    end
    
    resources :qiwicoin_transfers do
      as_routes
    end

    resources :bonuses do
      as_routes

      member do
        post :approve_tx
        post :decline_tx
      end
    end

  end

  
end
