Rails.application.routes.draw do
  
  #all the routes to normal pages
  get 'admin', to: 'pages#admin', as: 'admin'
  get 'home', to: 'pages#home', as: 'home'
  get 'holding', to: 'pages#holding', as: 'holding'
  get 'trade', to: 'pages#trade', as: 'trade'
  get 'leaderboard', to: 'pages#leaderboard', as: 'leaderboard'
  get 'mytransactions', to: 'pages#mytransactions', as: 'mytransactions'

  #all the routes to the making a trade pages
  get 'stock_select', to: 'pages#stock_select', as: 'stock_select'
  get 'stock_select', to: 'pages#trade'
  get 'trade', to: 'pages#trade'
  get 'purchase', to: 'pages#trade'
  get 'confirm', to: 'pages#trade'
  post 'stock_select', to: 'pages#stock_select'
  post 'trade', to: 'pages#view_trade'
  post 'purchase', to: 'pages#purchase'
  post 'confirm', to: 'pages#trade_confirm'
  
  #The route for chaging a asking price prosses
  get 'change_asking', to: 'pages#change_asking', as: 'change_asking'

  #all the routes for updating a holding
  match '/holding', to: 'pages#holding', via: 'patch'
  patch 'holding/:id(.:format)', to: 'pages#holding', action: :update
  put 'holding/:id(.:format)', to: 'pages#holding', action: :update

  #admin updateLeaderboard
  post 'admin', to: 'pages#admin'


  #root 
  devise_for :users
  root "pages#home"
end
