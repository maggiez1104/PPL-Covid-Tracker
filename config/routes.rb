Rails.application.routes.draw do

  # see why post is not working at all
  # why button click is registering as a get
  get '/people', to: "people#index"

  post '/search_form', to: 'people#search'

  get '/search_form', to: "people#search_form"

  post '/', to: 'people#search'
end
