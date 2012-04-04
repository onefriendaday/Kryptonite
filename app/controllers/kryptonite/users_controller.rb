module Kryptonite
  class UsersController < Kryptonite::KryptoniteController

    unloadable
  
    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @kryptonite_page_title = t("users_page_title")
    	@users = Kryptonite::User.paginate :order => "login", :page => params[:page]
    end
 
    def new
      @kryptonite_page_title = t("users_add_new")
    	@kryptonite_user = Kryptonite::User.new
    	@kryptonite_user.time_zone = Rails.configuration.time_zone
    end
  
    def create
      @kryptonite_user = Kryptonite::User.new params[:kryptonite_user]
    
      if @kryptonite_user.save
        flash[:notice] = t("users_email_sent_with_details", :username=>@kryptonite_user.name)
        redirect_to kryptonite_users_path
      else
        flash.now[:warning] = t("users_problems_saving_warning")
        render :action => :new
      end
    end
  
    def show
    	@kryptonite_user = Kryptonite::User.find params[:id]
    	@kryptonite_page_title = @kryptonite_user.name + " | " + t("users_show")
    end
 
    def update
      @kryptonite_user = Kryptonite::User.find params[:id]
      @kryptonite_page_title = @kryptonite_user.name + " | " + t("users_update")

      if @kryptonite_user.update_attributes params[:kryptonite_user]
        flash[:notice] = t("users_updated_notice", :username=>@kryptonite_user.name)
      else
        flash.now[:warning] = t("users_problems_updating")
        render :action => :show
        return
      end
      
      if @session_user.is_admin?
        redirect_to kryptonite_users_path
      else
        redirect_to :controller => :kryptonite, :action => :index
      end
    end
 
    def update_password
      @kryptonite_user = Kryptonite::User.find params[:id]
      @kryptonite_page_title = @kryptonite_user.name + " | " + t("users_update_password")
       
      if @kryptonite_user.valid_password? params[:form_current_password]
        if @kryptonite_user.update_attributes params[:kryptonite_user]
          flash.now[:notice] = t("users_password_changed_notice")
        else
          flash.now[:warning] = t("users_problems_changing_password")
        end
      else
        flash.now[:warning] = t("users_password_incorrect")
      end
      
      render :action => :show
    end
 
    def reset_password
      @kryptonite_user = Kryptonite::User.find params[:id]
      @kryptonite_page_title = @kryptonite_user.name + " | " + t("users_reset_password")
       
      @kryptonite_user.notify_of_new_password = true unless @kryptonite_user.id == @session_user.id
      
      if @kryptonite_user.update_attributes params[:kryptonite_user]
        if @kryptonite_user.id == @session_user.id
          flash.now[:notice] = t("users_password_reseted")
        else    
          flash.now[:notice] = t("users_password_reseted_and_emailed", :username=>@kryptonite_user.name)
        end
        
      else
        flash.now[:warning] = t("users_problems_reseting_password")
      end
      render :action => :show
    end
 
    def destroy
      user = Kryptonite::User.find params[:id]
      if user.is_admin? == false || Kryptonite::User.has_more_than_one_admin
        user.destroy
        flash[:notice] = t("users_deleted", :username=>user.name)
      end
      redirect_to kryptonite_users_path
    end
 
  end
end