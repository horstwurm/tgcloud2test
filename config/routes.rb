Rails.application.routes.draw do

  resources :deputies
  
  #devise_for :users
  resources :charges
  resources :sensors
  resources :idea_crowdratings
  resources :prices
  resources :crits
  resources :idea_ratings
  resources :criterias
  resources :ideas
  resources :plannings
  resources :timetracks
  resources :user_answers
  resources :answers
  resources :questions
  resources :mlikes
  resources :comments
  resources :edition_arcticles
  resources :editions
  resources :qrcodes
  resources :signage_hits
  resources :signage_cals
  get 'rooms/show'

  resources :credentials
  root 'home#index3'
  
  resources :webmasters
  resources :user_tickets
  resources :user_positions
  resources :transactions
  get 'ticketuserview/index'
  get 'ticketuserview/index2'
  get 'users/ticketstatus'
  resources :tickets
  get 'statement/index'

  get 'showcal/index'
  get 'home/nutzung'
  get 'home/index'
  get 'home/index1'
  #get 'home/index1/:ticket_id', to: 'home#index1'
  get 'home/index2'
  get 'home/index3'
  get 'home/index6'
  get 'home/index7'
  get 'home/index8'
  get 'home/index9'
  get 'home/index10'
  get 'home/index11'
  get 'home/index12'
  get 'home/index13'
  get 'home/index14'
  get 'home/index15'
  get 'home/index16'
  get 'home/index17'
  get 'home/index18'
  get 'home/import'
  get 'home/dashboard'
  get 'home/dashboard2'
  get 'home/dashboard_project'
  get 'home/dashboard_data'
  get 'home/dashboard2_data'
  get 'home/dashboard_projectdata'
  get 'home/Umfragen_data'
  get 'home/readsensordata'
  get 'home/writesensordata'
  
  resources :searches
  resources :partner_links
  resources :mstats
  resources :msponsors
  resources :mratings
  resources :mobjects
  resources :mdetails
  resources :mcategories
  resources :mcalendars
  resources :madvisors
  get 'listaccount/index'

  resources :favourits
  resources :emails
  resources :customers
  get 'customer_advisor/index'

  get 'customer_advisor/index2'
  get 'appparams/updateuser'
  
  resources :companies
  resources :appparams
  resources :appointments
  resources :appointment_documents
  resources :accounts
  root 'home#index3'

  #devise_for :users, :controllers => {registrations: 'registrations'}
  #devise_for :users, :controllers => {registrations: 'registrations', passwords: 'passwords', confirmations: "confirmations"}
  devise_for :users, :controllers => {registrations: 'registrations', passwords: 'passwords'}
  
  resources :users
  resources :tests
  
  # mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
