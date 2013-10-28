StreetShoutWorker1::Application.routes.draw do
  resources :scheduled_shouts
  root :to => 'scheduled_shouts#new'
end
