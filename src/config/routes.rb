Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  # static
  root 'amiverse#index'
  get 'about' => 'amiverse#about'
  get 'info' => 'amiverse#info'
  get 'help' => 'amiverse#help'
  get 'policy' => 'amiverse#policy'
  get 'disclaimer' => 'amiverse#disclaimer'
  get 'page1' => 'amiverse#page1'
  get 'sitemap' => 'amiverse#sitemap'

  # setting
  get 'settings' => 'settings#index'

  # account
  get '@:name_id' => 'accounts#show', as: 'account'
  get '@:name_id/icon' => 'accounts#show_icon', as: 'show_icon'
  get '@:name_id/banner' => 'accounts#show_banner', as: 'show_banner'
  get '@:name_id/edit' => 'accounts#edit', as: 'edit_account'
  patch '@:name_id/update' => 'accounts#update', as: 'update_account'
  get '@:name_id/password_edit' => 'accounts#password_edit', as: 'password_edit_account'
  patch '@:name_id/password_update' => 'accounts#password_update', as: 'password_update_account'
  delete '@:name_id' => 'accounts#destroy'

  # signup
  get 'signup' => 'signup#index'
  get 'signup/invitation' => 'signup#p1'
  post 'signup/profile' => 'signup#p2'
  post 'signup/create' => 'signup#p3'

  # session
  get 'sessions' => 'sessions#index'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create', as: 'create_session'
  delete 'logout' => 'sessions#destroy'

  # invitation
  get 'invitations' => 'invitations#index'
  get 'i-:invitation_code' => 'invitations#show', as: 'invitation'
  get 'i-:invitation_code/new' => 'invitations#new', as: 'new_invitation'
  post 'i-:invitation_code/create' => 'invitations#create', as: 'create_invitation'
  get 'i-:invitation_code/edit' => 'invitations#edit', as: 'edit_invitation'
  patch 'i-:invitation_code/update' => 'invitations#update', as: 'update_invitation'
  delete 'i-:invitation_code/destroy' => 'invitations#destroy', as: 'destroy_invitation'

  # item
  resources :items, param: 'item_id'

  # storage
  get 'storage' => 'storage#index'
  # img
  get 'storage/images' => 'storage#images'
  get 'storage/images/new' => 'storage#new_image'
  post 'storage/images/create' => 'storage#create_image'
  get 'storage/images/:image_id' => 'storage#show_image', as: 'show_image'
  # vdo
  get 'storage/videos' => 'storage#videos'
  get 'storage/videos/new' => 'storage#new_video'
  post 'storage/videos/create' => 'storage#create_video'
  get 'storage/videos/:video_id' => 'storage#show_video', as: 'show_video'

  # reaction
  get 'reactions' => 'reactions#index'
  post 'reactions' => 'reactions#create'
  get 'reactions/new' => 'reactions#new'
  post 'react/:item_id/:reaction_id' => 'reactions#react', as: 'react'

  # admin
  namespace :admin do

    # analytics
    root 'application#index'

    # account
    get 'accounts' => 'accounts#index'
    get '@:name_id' => 'accounts#show', as: 'account'
    get '@:name_id/edit' => 'accounts#edit', as: 'edit_account'
    patch '@:name_id/update' => 'accounts#update', as: 'update_account'

    # invitation
    get 'invitations' => 'invitations#index'
    get 'i-:invitation_code' => 'invitations#show', as: 'invitation'
    get 'i-:invitation_code/new' => 'invitations#new', as: 'new_invitation'
    post 'i-:invitation_code/create' => 'invitations#create', as: 'create_invitation'
    get 'i-:invitation_code/edit' => 'invitations#edit', as: 'edit_invitation'
    patch 'i-:invitation_code/update' => 'invitations#update', as: 'update_invitation'
    delete 'i-:invitation_code/destroy' => 'invitations#destroy', as: 'destroy_invitation'

    # session
    get 'sessions' => 'sessions#index', as: 'sessions'
    get 'sessions/:id' => 'sessions#show', as: 'show_session'
    get 'sessions/:id/edit' => 'sessions#edit', as: 'edit_session'
    patch 'sessions/:id/update' => 'sessions#update', as: 'update_session'
    delete 'sessions/:id/destroy' => 'sessions#destroy', as: 'destroy_session'

    # item
    get 'items' => 'items#index', as: 'items'
  end
  
  # api
  namespace :api do

    # analytics
    root 'application#index'

    # logged-in
    post 'logged-in' => 'application#logged_in', as: 'logged-in'

    # csrf token generate
    post 'new' => 'application#new', as: 'new'

    # account
    post '@:name_id' => 'accounts#show', as: 'account'

    # signup
    post 'check-invitation-code' => 'signup#check_invitation_code'
    post 'signup' => 'signup#create'

    # session
    post 'login' => 'sessions#create', as: 'login'
    delete 'logout' => 'sessions#destroy', as: 'logout'

    # item
    get 'items' => 'items#index', as: 'items'
    post 'items/create' => 'items#create', as: 'create_items'
    get 'items/:item_id' => 'items#show', as: 'item'
  end
end
