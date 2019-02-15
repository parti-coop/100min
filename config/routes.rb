Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'user/omniauth_callbacks' }
  root 'pages#home'
  get :faq, to: 'pages#faq'

  delete :cancel_current_user, to: 'users#cancel'
  delete :confirm_user, to: 'users#confirm'

  delete :likes, to: 'likes#destroy_by_current_user'
  resources :likes do
  end
  resources :stories
  resources :notices

  post '/tinymce_assets', to: 'tinymce_assets#create'
end
