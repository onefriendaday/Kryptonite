require 'authlogic'

module Kryptonite
  class KryptoniteController < ApplicationController

    unloadable

    require 'kryptonite/kryptonite_helper'
    include Kryptonite::KryptoniteHelper

  	require 'kryptonite/config_helper'
  	include Kryptonite::ConfigHelper

    layout 'kryptonite_main'
   
    helper_method :current_user_session, :current_user
    before_filter :authorise
    before_filter :set_time_zone
    before_filter :get_uploaded_file
    after_filter :destroy_uploaded_file
    
    ActionView::Base.field_error_proc = proc { |input, instance| "<span class='formError'>#{input}</span>".html_safe }

    def index		
  		redirect_to kryptonite_config_dashboard_url
    end

  	def blank
  		@kryptonite_page_title = t(:home_page_title)
  	end

  private
  
    def get_uploaded_file
      if params.has_key?(:qqfile)
        if params[:browser]=="opera"
          @tempname = params[:qqfile].original_filename
          file_content = File.open("#{Rails.root.to_s}/tmp/#{@tempname}", "wb") do |f| 
            f.write(params[:qqfile].read)
          end
        else
          @tempname = request.env['HTTP_X_FILE_NAME']
          file_content = File.open("#{Rails.root.to_s}/tmp/#{@tempname}", "wb") do |f| 
            f.write(request.env['rack.input'].read)
          end
        end
        @file = File.new("#{Rails.root.to_s}/tmp/#{@tempname}")
        #filename = "#{Rails.root.to_s}/tmp/#{tempname}"
      end
    end
    
    def destroy_uploaded_file
      if params.has_key?(:qqfile)
        File.unlink("#{Rails.root.to_s}/tmp/#{@tempname}")
      end
    end
  
    def authorise
      unless current_user
        session[:return_to] = request.fullpath
        redirect_to new_kryptonite_user_session_url
        return false
      end
    end
    
    def set_time_zone
      Time.zone = current_user.time_zone if current_user
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = Kryptonite::UserSession.find
    end

    def current_user
      return @session_user if defined?(@session_user)
      @session_user = current_user_session && current_user_session.user
    end
  
    def needs_admin
      unless @session_user.is_admin?
        redirect_to :controller => :kryptonite, :action => :index
      end
    end
  
    def needs_admin_or_current_user
      unless @session_user.is_admin? || params[:id].to_i == @session_user.id
        redirect_to :controller => :kryptonite, :action => :index
      end
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  end
end