require 'sidekiq/web'
Rails.application.routes.draw do

  #sidekiq
  mount Sidekiq::Web => '/sidekiq'
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
  end

  # action cable
  mount ActionCable.server => '/cable'

  root 'timelines#index'
  
  # discovery
  get 'discovery' => 'discovery#index'

  # dashboard
  get 'dashboard' => 'dashboard#index'

  # timeline
  get 'tl' => 'timelines#tl'
  get 'tl/follow' => 'timelines#follow'
  get 'tl/current' => 'timelines#current'
  get 'tl/group/:group_aid' => 'timelines#group'

  # account
  get '@:name_id' => 'accounts#show', as: 'account', constraints: { name_id: /[A-Za-z0-9\-_\.@]*/ }
  get '@:name_id/icon' => 'accounts#show_icon', as: 'show_icon', constraints: { name_id: /.*/ }
  get '@:name_id/banner' => 'accounts#show_banner', as: 'show_banner', constraints: { name_id: /.*/ }
  post '@:name_id/follow' => 'accounts#follow', as: 'follow', constraints: { name_id: /.*/ }
  patch '@:name_id/upate' => 'accounts#update', as: 'update_account'

  # item
  get 'items' => 'items#index'
  get 'items/new' => 'items#new', as: 'new_item'
  post 'items/create' => 'items#create', as: 'create_item'
  get 'items/:aid' => 'items#show', as: 'item'
  get 'items/:aid/edit' => 'items#edit', as: 'edit_item'
  patch 'items/:aid/update' => 'items#update', as: 'update_item'
  delete 'items/:aid/destroy' => 'items#destroy', as: 'destroy_item'

  # reaction
  post 'react/:item_id/:emoji_id' => 'reactions#react', as: 'react'

  # storage
  get 'storage' => 'storage#index'

  # image
  resources :images, param: :aid, only: %i[ show create update delete ]
  get 'images/:aid/icon' => 'images#show_icon'
  get 'images/:aid/banner' => 'images#show_banner'

  # video
  resources :videos, param: :aid, only: %i[ create update delete ]

  # notifications
  #resources :videos, param: :aid, only: %i[ create update delete ]
  get 'notifications' => 'notifications#index'
  get 'notifications/new' => 'notifications#new', as: 'new_notification'
  post 'notifications/create' => 'notifications#create', as: 'create_notification'

  # message
  get 'messages' => 'messages#index'
  get 'messages/:group_aid' => 'messages#show', as: 'message'
  post 'message/:group_aid/create' => 'messages#create', as: 'create_message'

  # group
  get 'groups' => 'groups#index'
  get 'groups/new' => 'groups#new', as: 'new_group'
  post 'groups/create' => 'groups#create', as: 'create_group'
  get 'groups/:aid' => 'groups#show', as: 'group'
  post 'groups/:group_aid/add/:account_aid' => 'groups#group_add', as: 'group_add'
  post 'groups/:group_aid/remove/:account_aid' => 'groups#group_remove', as: 'group_remove'

  # emoji
  get 'emojis' => 'emojis#index'
  get 'emojis/new' => 'emojis#new', as: 'new_emoji'
  post 'emojis/create' => 'emojis#create', as: 'create_emoji'
  get 'emojis/:aid' => 'emojis#show', as: 'emoji'
  get 'emojis/:aid/edit' => 'emojis#edit', as: 'edit_emoji'
  patch 'emojis/:aid/update' => 'emojis#update', as: 'update_emoji'
  delete 'emojis/:aid/destroy' => 'emojis#destroy', as: 'destroy_emoji'

  # tag
  get 'tags' => 'tags#index'
  get 'tags/new' => 'tags#new', as: 'new_tag'
  post 'tags/create' => 'tags#create', as: 'create_tag'
  get 'tags/:aid' => 'tags#show', as: 'tag'
  get 'tags/:aid/edit' => 'tags#edit', as: 'edit_tag'
  patch 'tags/:aid/update' => 'tags#update', as: 'update_tag'
  delete 'tags/:aid/destroy' => 'tags#destroy', as: 'destroy_tag'

  # list

  # wallet

  # a_shop

  # product

  # map

  # world

  # application

  # subscription

  # signup
  get 'signup' => 'signup#index'
  get 'signup/check' => 'signup#check'
  post 'signup/entry' => 'signup#entry'
  post 'signup/create' => 'signup#create'

  # session
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create', as: 'create_session'
  delete 'logout' => 'sessions#logout'

  # setting
  get 'settings' => 'settings#index'
  get 'settings/profile' => 'settings#profile'
  get 'settings/account' => 'settings#account'
  get 'settings/storage' => 'settings#storage'
  get 'settings/contents' => 'settings#contents'
  get 'settings/activity' => 'settings#activity'
  get 'settings/notifications' => 'settings#notifications'
  get 'settings/display' => 'settings#display'
  get 'settings/security_and_authority' => 'settings#security_and_authority'
  get 'settings/analytics' => 'settings#analytics'
  get 'settings/bills_and_payments' => 'settings#bills_and_payments'
  get 'settings/others' => 'settings#others'

  # resource
  get 'resources' => 'resources#index'
  get 'about' => 'resources#about'
  get 'info' => 'resources#info'
  get 'help' => 'resources#help'
  get 'privacy_policy' => 'resources#privacy_policy'
  get 'disclaimer' => 'resources#disclaimer'
  get 'page1' => 'resources#page1'
  get 'sitemap' => 'resources#sitemap'
  get 'tos' => 'resources#tos'
  get 'feedback' => 'resources#feedback'
  get 'help' => 'resources#help'
  get 'release_notes' => 'resources#release_notes'
  get 'blog' => 'resources#blog'

  # administorator
  namespace :admin do

    # dashboard
    root 'dashboard#index'

    # account
    resources :accounts, param: :aid, constraints: { name_id: /.*/ }, except: %i[ show ]

    # session
    resources :sessions, param: :uuid, except: %i[ show ]

    # invitation
    resources :invitations, param: :uuid, except: %i[ show ]

    # item
    get 'items' => 'items#index', as: 'items'

    # test
    get 'test' => 'test#index'
    get 'test/explore' => 'test#explore'
    get 'test/explore/:id' => 'test#show', constraints: { id: /.*/ }
    get 'test/new'
    post 'test/generate'
    post 'test/verify'
    post 'test/digest'
  end

  # api v1
  namespace :v1 do

    # app_status
    root 'resources#index'

    # session
    post 'sessions/new' => 'sessions#new'
    post 'sessions/check' => 'sessions#check'
    post 'login' => 'sessions#login'
    delete 'logout' => 'sessions#logout'

    # timeline
    post 'tl' => 'timelines#index'
    post 'tl/follow' => 'timelines#follow'#
    post 'tl/current' => 'timelines#current'#
    post 'tl/group/:group_aid' => 'timelines#group'#

    # account
    post '@:name_id' => 'accounts#show', as: 'account'
    post '@:name_id/followers' => 'accounts#followers', as: 'followers'
    post '@:name_id/following' => 'accounts#following', as: 'following'

    # signup
    post 'signup/check' => 'signup#check'
    post 'signup/create' => 'signup#create'

    # item
    post 'items' => 'items#index', as: 'items'
    post 'items/create' => 'items#create', as: 'create_items'
    post 'items/:item_id' => 'items#show', as: 'item'

    # activity pub
    post 'activitypub/inbox' => 'activity_pub#inbox'
  end

  # activity pub
  namespace :ap do
    # account
    get '@:name_id' => 'accounts#show', as: 'account'
    post '@:name_id/inbox' => 'accounts#inbox', as: 'account_inbox'
    get '@:name_id/outbox' => 'accounts#outbox', as: 'account_outbox'
    get '@:name_id/followers' => 'accounts#followers', as: 'account_followers'
    get '@:name_id/following' => 'accounts#following', as: 'account_following'
  end

  # .well-known
  get '/.well-known/host-meta' => 'well_known#host_meta'
  get '/.well-known/webfinger' => 'well_known#webfinger'

end
