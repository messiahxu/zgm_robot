class Admin::RobotsController < ApplicationController
  before_filter :logined?

  def index
    @history = Robot.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def delete
    Robot.delete(params[:id])
  end

  def learn
    flash.now[:warn] = 'this operation is dangerous, be careful!'
  end

  def learn_words
    unless params[:pattern].blank? || params[:template].blank?
      Robot.learn params[:pattern],params[:template]
      Robot.dump
      flash.now[:success] = 'learn success.'
    else
      flash.now[:error] = 'pattern or templay can\'t be empty.'
    end
    render '/admin/robots/learn'
  end

end
