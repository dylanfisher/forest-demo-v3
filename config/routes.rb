Rails.application.routes.draw do
  # Root
  root to: 'home_pages#show'
  get '/home', to: redirect('/')
end
