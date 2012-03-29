module Kryptonite
  
  class KryptoniteNotification < ActionMailer::Base
	
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'kryptonite')
	
  	def generate_new_password from, kryptonite_user, host, pass
  		@name = kryptonite_user.name
  		@host = host
  		@login = kryptonite_user.login
  		@pass = pass
  		@from_text = kryptonite_config_website_name
  		
  		mail(:to => kryptonite_user.email, :from => from, :subject => t("new_password_subject", :website_name=>kryptonite_config_website_name))
  	end
  
  	def new_user_information from, kryptonite_user, host, pass
      @name = kryptonite_user.name
  		@host = host
  		@login = kryptonite_user.login
  		@pass = pass
  		@from_text = kryptonite_config_website_name
  		
  		mail(:to => kryptonite_user.email, :from => from, :subject => t("new_account_subject", :website_name=>kryptonite_config_website_name))
  	end
  	
  	def password_reset_instructions from, kryptonite_user, host
  	  ActionMailer::Base.default_url_options[:host] = host.gsub("http://", "")
      @name = kryptonite_user.name
      @host = host
      @login = kryptonite_user.login
      @reset_password_url = edit_kryptonite_password_reset_url + "/?token=#{kryptonite_user.perishable_token}"
      @from_text = kryptonite_config_website_name

      mail(:to => kryptonite_user.email, :from => from, :subject => t("password_reset_subject", :website_name=>kryptonite_config_website_name))
    end

  end
end