module Kryptonite
  class PasswordResetsController < Kryptonite::KryptoniteController
  
    unloadable
  
    skip_before_filter :authorise
    before_filter :load_user_using_perishable_token, :only => [:edit, :update]

    layout 'kryptonite_auth'
    
    def create
      users = Kryptonite::User.where(:email => params[:recover_email]).all

      if users.length > 0
        users.each do |user|
          user.send_password_reset_instructions
        end

        if users.length > 1
          flash[:notice] = t(:multiple_acctounts_notice, :email=>params[:recover_email])
        else
          flash[:notice] = t(:email_sent_notice, :email=>params[:recover_email])
        end
      else
        flash[:warning] = t(:no_user_warning)
      end

      redirect_to new_kryptonite_user_session_url
    end

    def edit
      render
    end

    def update
      
      if params[:kryptonite_user][:password].empty? || params[:kryptonite_user][:password_confirmation].empty?
        flash.now[:warning] = t(:field_empty_warning)
      else
      
        @reset_user.password = params[:kryptonite_user][:password]
        @reset_user.password_confirmation = params[:kryptonite_user][:password_confirmation]
      
        if @reset_user.save
          flash[:notice] = t(:password_updated_notice)
          redirect_to new_kryptonite_user_session_url
          return
        end
      end
      
      render :action => :edit
    end

  private
    
    def load_user_using_perishable_token
      
      @reset_user = Kryptonite::User.find_using_perishable_token params[:token]
      
      unless @reset_user
        flash[:warning] = t(:account_not_located_warning)
        redirect_to new_kryptonite_user_session_url
      end
    end
  end
end