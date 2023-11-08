
Rails.application.routes.draw do
  # Root path
  root 'sessions#new'
  

  get 'sign_up', to: 'users#new', as: :new_user
  post 'users', to: 'users#create', as: :users
  get 'user/:id', to: 'users#show', as: :user_page  # Assuming you have a show action in UsersController
  get 'sign_in', to: 'sessions#new', as: :new_session
  post 'sign_in', to: 'sessions#create', as: :session  # Assuming you have a create action in SessionsController
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out  # Assuming you have a destroy action in SessionsController

  # Define a route for the game history page
  get 'games/history', to: 'games#history', as: :history_games
  

  resources :games, only: [:new, :create, :show] 


  # Optionally, if you have a page to play a new game
  get 'play_new_game', to: 'games#new', as: :play_new_game  # This might be redundant if you have resources :games
  
  resources :games do
    member do
      get 'replay'
    end
  end

end
