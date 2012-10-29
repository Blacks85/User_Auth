UserAuth::Application.routes.draw do

	get "sessions/login"	
	match "login", :to => "sessions#login"
  	get "sessions/home"
	match "home", :to => "sessions#home"
  	get "sessions/logout"
	match "logout", :to => "sessions#logout"	
	match "login_attempt", :to => "sessions#login_attempt"
  
  	get "users/new"
  	match "signup", :to => "users#new"
  	match "create", :to => "users#create"
  	
end
