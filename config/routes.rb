Rails.application.routes.draw do
  
  match "/admin" => redirect("/kryptonite")
  
  namespace :kryptonite do
  
    resources :users do
      member do
        put :update_password, :reset_password
      end
    end
    
    resource :user_session
    resource :password_reset, :only => [:create, :edit, :update]
        
    match "/blank" => "kryptonite#blank"
    root :to => "kryptonite#index"
  end
  
end