class RobotsController < ApplicationController
  NullReply = 'You gotta say something.'
  ChineseReply = 'Sorry I can\'t speak Chinese.'

  def index
  end

  def chat
    @receive = params[:receive].gsub(/[^\)a-zA-Z0-9]$/,'')
    change_session_or_not
    $last_user = session[:user]
    ProgramR::History.saving "lib/programr/lib/session/#{session[:user]}" 
    @reply = Robot.reply(@receive).gsub(/\#.*$/, '')
    Robot.create({
      :username=>ProgramR::Environment.get_readOnlyTags['name'], 
      :receive=>@receive,
      :reply=>@reply[0..100]
    })
  end


  private
  def change_session_or_not
    if session[:user].blank?
      session[:user] = request.session_options[:id]
      ProgramR::History.init
    elsif $last_user != session[:user]
      if File.exist?("lib/programr/lib/session/#{session[:user]}")
        ProgramR::History.loading "lib/programr/lib/session/#{session[:user]}"
      end
    end

  end
end
