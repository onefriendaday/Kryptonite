module Kryptonite
  module ConfigHelper
    
  	# Text string containing the name of the website or client
  	# Used in text and titles throughout Kryptonite
    def kryptonite_config_website_name
    	'Kryptonite'
    end

  	# URL to the logo used for the login screen and top banner - it should be a transparent PNG
    def kryptonite_config_logo
    	'/kryptonite/images/kryptonite.png'
    end

  	# The server hostname where Kryptonite will run
    def kryptonite_config_hostname
      if ENV['RAILS_ENV'] == 'production'
        'http://www.kryptonitecms.com'
      else
        'http://localhost:3000'
      end
    end

  	# The sender email address used for notifications
  	def kryptonite_config_email_from_address
  		'donotreply@kryptonitecms.com'
  	end
	
  	# The page that the user is shown when they login or click the logo
  	# do not point this at kryptonite/index!
  	def kryptonite_config_dashboard_url
  		url_for :controller => :kryptonite, :action => :blank
  	end
	
  	# A list of stylesheet files to include in the page head section
  	def kryptonite_config_stylesheet_includes
  		%w[/kryptonite/stylesheets/custom /kryptonite/stylesheets/screen /kryptonite/stylesheets/elements]
  	end
	
  	# A list of JavaScript files to include in the page head section
  	def kryptonite_config_javascript_includes
  	  %w[/kryptonite/javascripts/jquery /kryptonite/javascripts/custom /kryptonite/javascripts/kryptonite /kryptonite/javascripts/rails]
  	end
  	
  end
end