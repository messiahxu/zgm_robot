class Admin::RobotsController < ApplicationController
  before_filter :logined?

  def index
    @history = Robot.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def wikis
    @wikis = Wiki.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def delete
    Robot.delete(params[:id])
  end

  def delete_wiki
    Wiki.delete(params[:id])
  end

  def clear_wikis
    flash[:success] = 'clear success'
    Wiki.delete_all
    redirect_to :back
  end
  def clear 
    flash[:success] = 'clear success'
    Robot.delete_all
    redirect_to :back
  end

  def learn
    
  end

  def learn_words
    unless params[:pattern].blank? || params[:template].blank?
      Robot.learn params[:pattern],params[:template]
      Robot.dump
      flash[:success] = 'learn success.'
    else
      flash[:error] = 'pattern or templay can\'t be empty.'
    end
    redirect_to :back
  end

  def learn_aiml
    file = params[:aiml]
    unless file.blank?
      begin
        $robot.parser.parse file.read
      rescue => err
        err
      end
    else
      flash[:error] = 'no file to learn'
    end
    redirect_to :back
  end

  def refresh
    Robot.dump
    File.open('./lib/programr/lib/cache/init.cache','r') do |f|
      cache = Marshal.load(f.read)
      $robot.graph_master.merge cache if cache
      flash[:success] = 'cache refresh success'
      redirect_to :back
    end
  end

end
