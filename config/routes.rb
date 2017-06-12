Rails.application.routes.draw do
  get 'dash_board/home'

  get 'dash_board/help'


  root 'dash_board#home'
  
  resources :articles
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
