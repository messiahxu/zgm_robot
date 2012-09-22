class ApplicationController < ActionController::Base
  protect_from_forgery
  include ExceptionLogger::ExceptionLoggable
  rescue_from Exception, :with => :log_exception_handler
  def logined?
    if session[:admin].blank?
      flash[:error] = 'you should login first.'
      redirect_to '/admin/login'
    end
  end
end
