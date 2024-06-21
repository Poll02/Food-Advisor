Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #route for critic_profile
  get 'critic_profile', to: 'profile#critic_profile'
end
