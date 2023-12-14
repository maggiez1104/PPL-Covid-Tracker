Rails.application.routes.draw do
  resources :people

  root "articles#index"

  # see why post is not working at all
  # why button click is registering as a get
  get '/people', to: "people#index"

  get '/people/new', to: "people#new"

  get '/calculator', to: 'calculator#index'

  post '/search_form', to: 'people#search'
  #post '/search_form', to: 'people#index'

  get '/search_form', to: "people#search_form"

  post '/', to: 'people#search'
end
