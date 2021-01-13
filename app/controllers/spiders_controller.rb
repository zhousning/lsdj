#require "spider_tool"
load "spider_tool.rb"

class SpidersController < ApplicationController
  layout "application_control"
  #before_filter :authenticate_user!
  #load_and_authorize_resource


  def start 
    @spider = Spider.find(params[:id])
    spider_tool = SpiderTool.new
    spider_tool.process(@spider) 
    redirect_to @spider
  end
   
  def index
    @spiders = Spider.all
  end
   

   
  def show
    @spider = Spider.find(params[:id])
  end
   

   
  def new
    @spider = Spider.new
    
    @spider.selectors.build
    
  end
   

   
  def create
    @spider = Spider.new(spider_params)
    #@spider.user = current_user
    if @spider.save
      redirect_to @spider
    else
      render :new
    end
  end
   

   
  def edit
    @spider = Spider.find(params[:id])
  end
   

   
  def update
    @spider = Spider.find(params[:id])
    if @spider.update(spider_params)
      redirect_to spider_path(@spider) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @spider = Spider.find(params[:id])
    @spider.destroy
    redirect_to :action => :index
  end
   

  private
    def spider_params
      params.require(:spider).permit( :link, :cookie, :header, :agent, :doc_parse, :content_type, :page, :file, :referer, :doc_save, :host, :redirection, selectors_attributes: selector_params)
    end
  
  
    def selector_params
      [:id, :name, :category, :title]
    end
  
end

