module Kryptonite
  class UserSessionsController < Kryptonite::KryptoniteController
    
    unloadable
    
    skip_before_filter :authorise, :only => [:new, :create]
    before_filter :requires_no_session_user, :except => [:destroy]
  
    layout 'kryptonite_auth'
  
    def new
      @user_session = Kryptonite::UserSession.new
    end
  
    def create
      @user_session = Kryptonite::UserSession.new params[:kryptonite_user_session]
      if @user_session.save
        flash[:notice] = "Login successful"
        redirect_back_or_default :controller => :kryptonite, :action => :index
      else
        render :action => :new
      end
    end
  
    def destroy
      current_user_session.destroy
      flash[:notice] = "Logout successful"
      redirect_back_or_default new_kryptonite_user_session_url
    end

  private
  
    def requires_no_session_user
      if current_user
        redirect_to :controller => :kryptonite, :action => :index
      end
    end

  end
end