Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get :weather_forecast, to: 'weather_forecast#index'
    end
  end
end
