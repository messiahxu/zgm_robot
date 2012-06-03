class ApplicationController < ActionController::Base
  protect_from_forgery
  def logined?
    if session[:admin].blank?
      flash[:error] = 'you should login first.'
      redirect_to '/admin/login'
    end
  end
end
