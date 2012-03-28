require "kryptonite"
require "rails"

module Kryptonite
  class Engine < Rails::Engine
    
    rake_tasks do
      load "railties/tasks.rake"
    end
    
  end
  
  class RouteConstraint

     def matches?(request)
       return false if request.fullpath.include?("/kryptonite")
       return false if request.fullpath.include?("/admin")
       true
     end

   end
end