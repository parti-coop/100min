Rails.application.routes.draw do
  mount LetsencryptPlugin::Engine, at: '/'

  devise_for :users, controllers: { omniauth_callbacks: 'user/omniauth_callbacks' }
  root 'pages#home'
  get :faq, to: 'pages#faq'
  get :about, to: 'pages#about'
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
  resources :comments, only: :index

  post '/tinymce_assets', to: 'tinymce_assets#create'
end
