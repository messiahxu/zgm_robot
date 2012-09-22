class RobotsController < ApplicationController
  NullReply = 'You gotta say something.'
  ChineseReply = 'Sorry I can\'t speak Chinese.'

  def index
  end

  def chat
    @receive = params[:receive].gsub(/\s*[.?!]*\s*$/, '')
    if session[:history]
      ProgramR::History.get_from_session session[:history]
    else
      ProgramR::History.init
    end
    begin
      @reply = Robot.reply(@receive).gsub(/\#.*$/, '')
    rescue => err
      @reply = 'Server is busy now.'
    end
    session[:history] = ProgramR::History.save_to_session
  end
end
