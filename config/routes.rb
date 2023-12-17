Rails.application.routes.draw do
  resources :people

  root "articles#index"

  get '/people', to: "people#index"

  get '/people/new', to: "people#new"

  get '/calculator', to: 'calculator#index', as: 'calculator'

  get '/search/calculator', to: 'calculator#index', as: 'search_calculator'

  post '/search_form', to: 'people#search'

  get '/search_form', to: "people#search_form"

  post '/', to: 'people#search'
end
