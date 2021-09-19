Rails.application.routes.draw do
  root :to => 'top#index'
  resource :posts, only: [:show, :edit]
end
