
Rails.application.routes.draw do
  # Root path
  root 'sessions#new'
  

  get 'sign_up', to: 'users#new', as: :new_user
  post 'users', to: 'users#create', as: :users
  get 'user/:id', to: 'users#show', as: :user_page 
  get 'sign_in', to: 'sessions#new', as: :new_session
  post 'sign_in', to: 'sessions#create', as: :session  
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out  


  get 'games/history', to: 'games#history', as: :history_games
  

  resources :games, only: [:new, :create, :show] 



  get 'play_new_game', to: 'games#new', as: :play_new_game  
  
  resources :games do
    member do
      get 'replay'
    end
  end

end
