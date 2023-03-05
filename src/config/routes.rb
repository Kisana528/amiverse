Rails.application.routes.draw do
  # static
  root 'amiverse#index'
  get 'about' => 'amiverse#about'
  get 'info' => 'amiverse#info'
  get 'help' => 'amiverse#help'
  get 'policy' => 'amiverse#policy'
  get 'disclaimer' => 'amiverse#disclaimer'
  get 'page1' => 'amiverse#page1'

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
  end
end
