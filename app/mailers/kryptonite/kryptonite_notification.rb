module Kryptonite
  
  class KryptoniteNotification < ActionMailer::Base
	
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'kryptonite')
	
  	def generate_new_password from, kryptonite_user, host, pass
  		@name = kryptonite_user.name
  		@host = host
  		@login = kryptonite_user.login
  		@pass = pass
  		@from_text = kryptonite_config_website_name
  		
  		mail(:to => kryptonite_user.email, :from => from, :subject => "[#{kryptonite_config_website_name}] New password")
  	end
  
  	def new_user_information from, kryptonite_user, host, pass
      @name = kryptonite_user.name
  		@host = host
  		@login = kryptonite_user.login
  		@pass = pass
  		@from_text = kryptonite_config_website_name
  		
  		mail(:to => kryptonite_user.email, :from => from, :subject => "[#{kryptonite_config_website_name}] New user account")
  	end
  	
  	def password_reset_instructions from, kryptonite_user, host
  	  ActionMailer::Base.default_url_options[:host] = host.gsub("http://", "")
      @name = kryptonite_user.name
      @host = host
      @login = kryptonite_user.login
      @reset_password_url = edit_kryptonite_password_reset_url + "/?token=#{kryptonite_user.perishable_token}"
      @from_text = kryptonite_config_website_name

      mail(:to => kryptonite_user.email, :from => from, :subject => "[#{kryptonite_config_website_name}] Password reset instructions")
    end

  end
end