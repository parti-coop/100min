Rails.application.routes.draw do
  mount AcmePlugin::Engine, at: '/'

  devise_for :users, controllers: { omniauth_callbacks: 'user/omniauth_callbacks' }
  root 'pages#home'
  get :faq, to: 'pages#faq'

  get :about, to: 'pages#about'
  get :caution, to: 'pages#caution'
  get :map, to: 'pages#map'
  get :schedule, to: 'pages#schedule'
  get :application, to: 'pages#application'
  get 'sites/:area_code', to: 'pages#site', as: :site

  get :group, to: 'pages#group'

  get :privacy, to: 'pages#privacy'
  get :terms, to: 'pages#terms'

  get 'dreams/value', to: 'dreams#value'
  get 'dreams/interview', to: 'dreams#interview'
  get 'dreams/data', to: 'dreams#data'

  delete :cancel_current_user, to: 'users#cancel'
  delete :confirm_user, to: 'users#confirm'

  delete :likes, to: 'likes#destroy'
  resources :likes

  concern :commentable do
    resources :comments, shallow: true
  end
  resources :stories, concerns: :commentable
  resources :notices, concerns: :commentable
  resources :suggestions, concerns: :commentable
  resources :snapshots, concerns: :commentable
  resources :kommentables, concerns: :commentable
  resources :comments, only: :index

  post '/tinymce_assets', to: 'tinymce_assets#create'

  post 'users/confirm', to: 'users#confirm'
  get 'users/confirm_form', to: 'users#confirm_form'

  match '/404', to: 'errors#not_found', via: :all, as: :error_404
  match '/401', to: 'errors#unauthorized', via: :all, as: :error_401
  match '/403', to: 'errors#forbidden', via: :all, as: :error_403
  match '/500', to: 'errors#internal_server_error', via: :all, as: :error_500

  namespace :admin do
    root to: 'users#index'
  end
end
