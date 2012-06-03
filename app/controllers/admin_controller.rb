class AdminController < ApplicationController
  def login
    unless session[:admin].blank?
      redirect_to '/admin/robots/index'
    end
  end

  def authenticate
    username = params[:username]
    password = params[:password]
    if Admin.find_by_username(username).try(:authenticate,password).blank?
      flash[:error] = 'wrong username or password.'
      redirect_to '/admin/login'
    else
      flash[:success] = 'welcome you.'
      session[:admin] = username  
      redirect_to '/admin/robots/index'
    end

  end

  def logout
    if session[:admin]
      session[:admin].clear
    end
    flash[:success] = 'logout success.'
    redirect_to '/'
  end
end
