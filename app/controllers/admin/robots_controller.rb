class Admin::RobotsController < ApplicationController
  before_filter :logined?

  def index
    unless params[:status]
      @history = Robot.order('created_at DESC').
                       paginate(:page => params[:page], 
                                :per_page => 20)
    else
      @history = Robot.order('created_at DESC').
                       where(:status => params[:status]).
                       paginate(:page => params[:page], 
                                :per_page => 20)
    end
  end

  def wikis
    @wikis = Wiki.order('created_at DESC').
                  paginate(:page => params[:page], 
                           :per_page => 20)
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

  def edit
    @robot = Robot.find(params[:id])
  end

  def learn

  end

  def update
    @robots = Robot.find_all_by_receive(params[:pattern])
    @robots.each do |r|
      r.update_attributes(:receive=>params[:pattern], :reply=>params[:template], :status=>1)
    end
    learn_words
  end

  def learn_words
    unless params[:pattern].blank?
      Robot.learn params[:pattern],params[:template]
      flash[:success] = 'learn success.'
    else
      flash[:error] = 'pattern or templay can\'t be empty.'
    end
    redirect_to :back
  end

  def learn_aiml
    t = Time.now
    file = params[:aiml]
    unless file.blank?
      begin
        $robot.parser.parse file.read
        flash[:success] = 'learn success ' + ((Time.now-t).round 2).to_s + ' s'
      rescue => err
        err
      end
    else
      flash[:error] = 'no file to learn'
    end
    redirect_to :back
  end

  def refresh
    t = Time.now
    Robot.dump
    File.open('./lib/programr/lib/cache/init.cache','r') do |f|
      cache = Marshal.load(f.read)
      $robot.graph_master.merge cache if cache
      flash[:success] = 'cache refresh success, use ' + ((Time.now-t).round 2).to_s + ' s'
      redirect_to :back
    end
  end

  def redis
    @redis = $redis.get 'my_aiml'
  end

  def update_redis
    time = Time.now
    $robot.parser.parse params[:redis]
    $redis.set 'my_aiml', params[:redis]
    flash[:success] = 'update redis success' + ' use ' + ((Time.now-time).round 2).to_s + ' s'
    redirect_to :back
  end

  def clear_redis
    $redis.set('my_aiml',IO.read('./lib/programr/lib/aiml/my.aiml'))
  end

  def logs
    @logs = Logs.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def search
    if params[:robot]
      @history = Robot.where("receive like '%#{params[:robot]}%'").order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
      render :index
    else params[:wiki]
      wiki = params[:wiki].camelize.gsub! /\s/, '_'
      @wikis = Wiki.where("receive like '%#{wiki}%'").order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
      render :wikis
    end
  end
end
