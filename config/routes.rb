Spree::Core::Engine.routes.draw do
  
  # Add your extension routes here
  
   #match '/tickets/open' => 'Tickets#open'

   
  namespace :support do 
    resources :tickets do
      collection do
        get 'open'
        get 'close'
        get 'all'
      end
      member do
        get 'closed'
      end      
    end
  end
  
  
  namespace :admin do 
    resources :tickets do
      collection do
        get 'myopen'
        get 'myclose'
        get 'myall'
        get 'unassigned'
        get 'all'
      end
      member do
        get 'closed'
      end      
    end
  end
  
  # resources :posts, :path => "/support/tickets"
  # resources :tickets, :path => "/support/tickets"
  # scope :module => "aa" do
  #   resources :tickets
  # end
  
end
