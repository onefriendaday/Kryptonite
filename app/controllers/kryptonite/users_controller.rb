module Kryptonite
  class UsersController < Kryptonite::KryptoniteController

    unloadable
  
    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @kryptonite_page_title = "Users"
    	@users = Kryptonite::User.paginate :order => "login", :page => params[:page]
    end
 
    def new
      @kryptonite_page_title = "Add a new user"
    	@kryptonite_user = Kryptonite::User.new
    	@kryptonite_user.time_zone = Rails.configuration.time_zone
    end
  
    def create
      @kryptonite_user = Kryptonite::User.new params[:kryptonite_user]
    
      if @kryptonite_user.save
        flash[:notice] = "An email has been sent to " + @kryptonite_user.name + " with the new account details"
        redirect_to kryptonite_users_path
      else
        flash.now[:warning] = "There were problems when trying to create a new user"
        render :action => :new
      end
    end
  
    def show
    	@kryptonite_user = Kryptonite::User.find params[:id]
    	@kryptonite_page_title = @kryptonite_user.name + " | View User"
    end
 
    def update
      @kryptonite_user = Kryptonite::User.find params[:id]
      @kryptonite_page_title = @kryptonite_user.name + " | Update User"

      if @kryptonite_user.update_attributes params[:kryptonite_user]
        flash[:notice] = @kryptonite_user.name + " has been updated"
      else
        flash.now[:warning] = "There were problems when trying to update this user"
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
      @kryptonite_page_title = @kryptonite_user.name + " | Update Password"
       
      if @kryptonite_user.valid_password? params[:form_current_password]
        if @kryptonite_user.update_attributes params[:kryptonite_user]
          flash.now[:notice] = "Your password has been changed"
        else
          flash.now[:warning] = "There were problems when trying to change the password"
        end
      else
        flash.now[:warning] = "The current password is incorrect"
      end
      
      render :action => :show
    end
 
    def reset_password
      @kryptonite_user = Kryptonite::User.find params[:id]
      @kryptonite_page_title = @kryptonite_user.name + " | Reset Password"
       
      @kryptonite_user.notify_of_new_password = true unless @kryptonite_user.id == @session_user.id
      
      if @kryptonite_user.update_attributes params[:kryptonite_user]
        if @kryptonite_user.id == @session_user.id
          flash.now[:notice] = "Your password has been reset"
        else    
          flash.now[:notice] = "Password has been reset and " + @kryptonite_user.name + " has been notified by email"
        end
        
      else
        flash.now[:warning] = "There were problems when trying to reset this user's password"
      end
      render :action => :show
    end
 
    def destroy
      user = Kryptonite::User.find params[:id]
      if user.is_admin? == false || Kryptonite::User.has_more_than_one_admin
        user.destroy
        flash[:notice] = user.name + " has been deleted"
      end
      redirect_to kryptonite_users_path
    end
 
  end
end