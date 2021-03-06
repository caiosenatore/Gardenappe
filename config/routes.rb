Rails.application.routes.draw do
  get 'dashboard/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'user#login'

  # Define user scope
  scope :backstage do
    resources :dashboard do
      get :index
    end

    resources :user do
      get :thankyou
      get :confirmemail

      collection do
        # Curent_user management
        get :index
        get :myinformation
        get :myphoto
        get :list
        post :updatecurrentuser

        # Authenticate routes
        get :login
        get :logout
        post :authenticate

        # Singles
        get :singlecountusers
      end
    end
  end
end