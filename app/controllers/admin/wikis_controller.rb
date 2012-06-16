class Admin::WikisController < ApplicationController
  before_filter :logined?

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.update_attributes(params[:wiki])
    flash[:success] = 'update success'
    redirect_to :back
  end
end
