Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'user/omniauth_callbacks' }
  root 'pages#home'

  delete :cancel_current_user, to: 'users#cancel'
end
