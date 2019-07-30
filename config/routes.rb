Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'
  get 'set_url', to: 'urls#set_url'
  get '/:id', to: 'urls#get_url'
end
