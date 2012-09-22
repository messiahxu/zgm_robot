class AdminController < ApplicationController
  def login
    unless session[:admin].blank?
      redirect_to '/admin/robots/index'
    end
  end

  def authenticate
    username = params[:username]
    password = params[:password]
    if Admin.find_by_username(username).try(:authenticate, password).blank?
      flash[:error] = 'wrong username or password.'
      redirect_to '/admin/login'
    else
      flash[:success] = 'welcome you.'
      session[:admin] = username
      redirect_to '/admin/robots/index'
    end
  end

  def change_password
    old_password = params[:old_password]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    @admin = Admin.find_by_username(session[:admin])
    if @admin.try(:authenticate,old_password).blank?
      flash[:error] = 'password is wrong'
    else
      if @admin.update_attributes(:password=>password, :password_confirmation=>password_confirmation)
        flash[:success] = 'password change success'
      else
        flash[:error] = 'password change failed'
      end
    end
    redirect_to :back
  end

  def logout
    if session[:admin]
      session[:admin].clear
    end
    flash[:success] = 'logout success.'
    redirect_to '/'
  end

end
