Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/'

  namespace :api do
    namespace :v1 do
      resources :verticals do
        resources :categories
      end
    end
  end
end
