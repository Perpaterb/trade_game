Rails.application.routes.draw do
  
  get 'admin', to: 'pages#admin', as: 'admin'
  get 'home', to: 'pages#home', as: 'home'
  get 'holding', to: 'pages#holding', as: 'holding'
  get 'trade', to: 'pages#trade', as: 'trade'
  get 'leaderboard', to: 'pages#leaderboard', as: 'leaderboard'
  get 'mytransactions', to: 'pages#mytransactions', as: 'mytransactions'
  
  get 'change_asking', to: 'pages#change_asking', as: 'change_asking'

  devise_for :users
  root "pages#home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
