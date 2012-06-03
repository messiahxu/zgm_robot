class RobotsController < ApplicationController
  NullReply = 'You gotta say something.'
  ChineseReply = 'Sorry I can\'t speak Chinese.'

  def index
  end

  def chat
    receive = params[:receive]

    if session[:user].blank?
      session[:user] = request.session_options[:id]
      ProgramR::History.init
    elsif $last_user != session[:user]
      if File.exist("tmp/my_sessions/#{session[:user]}")
        ProgramR::History.loading "tmp/my_sessions/#{session[:user]}"
      end
    else
      p 'welcome back'
    end
    $last_user = session[:user]
    if receive.blank?
      @reply = NullReply
    elsif receive =~ /[\u4e00-\u9fa5]/
      @reply = ChineseReply
    else
      @reply = $robot.get_reaction(receive).gsub(/\#.*$/, '')
    end

    ProgramR::History.saving "tmp/my_sessions/#{session[:user]}" 
    Robot.create({
      :username=>ProgramR::Environment.get_readOnlyTags['name'], 
      :receive=>receive,
      :reply=>@reply
    })
  end

end
