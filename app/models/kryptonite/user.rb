include Kryptonite::ConfigHelper

$KRYPTONITE_USER_ACCESS_LEVEL_ADMIN = 0
$KRYPTONITE_USER_ACCESS_LEVEL_USER = 10

module Kryptonite
  class User < ActiveRecord::Base

	  def self.table_name
      self.to_s.gsub("::", "_").tableize
    end

    acts_as_authentic { |c| c.validate_email_field = false }
	 
    attr_accessor :notify_of_new_password
    
    attr_accessible :login, :name, :email, :time_zone, :access_level, :password, :password_confirmation
	 
    after_create :send_create_notification
    after_update :send_update_notification
    before_validation :check_time_zone
    
    validates_presence_of :login, :name, :email
    validates_uniqueness_of :login
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    validates_presence_of :time_zone
	  
  	def self.has_more_than_one_admin
      Kryptonite::User.where(:access_level => $KRYPTONITE_USER_ACCESS_LEVEL_ADMIN).count > 1
    end
	
  	def send_create_notification
      Kryptonite::KryptoniteNotification.new_user_information(kryptonite_config_email_from_address, self, kryptonite_config_hostname, @password).deliver
    end
  
    def send_update_notification
      if notify_of_new_password
        notify_of_new_password = false
        Kryptonite::KryptoniteNotification.generate_new_password(kryptonite_config_email_from_address, self, kryptonite_config_hostname, @password).deliver
      end
    end
    
    def send_password_reset_instructions
      reset_perishable_token!
      Kryptonite::KryptoniteNotification.password_reset_instructions(kryptonite_config_email_from_address, self, kryptonite_config_hostname).deliver
    end
    
    def check_time_zone
      self.time_zone = Rails.configuration.time_zone unless self.time_zone
    end
	
  	def is_admin?
  	  access_level == $KRYPTONITE_USER_ACCESS_LEVEL_ADMIN
  	end
  
  end
end
