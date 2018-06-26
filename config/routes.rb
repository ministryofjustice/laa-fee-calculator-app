Rails.application.routes.draw do
  root to: 'calculator#new'

  get 'calculator/new'
  get 'calculator/calculate'
  get 'calculator/fee_scheme_changed'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
