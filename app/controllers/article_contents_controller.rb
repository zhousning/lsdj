class ArticleContentsController < ApplicationController
  #layout "application_control"
  #before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @article_contents = ArticleContent.all
  end
   

   
  def show
    @article_content = ArticleContent.find(params[:id])
  end
   

   
  def new
    @article_content = ArticleContent.new
    
  end
   

   
  def create
    @article_content = ArticleContent.new(article_content_params)
    #@article_content.user = current_user
    if @article_content.save
      redirect_to @article_content
    else
      render :new
    end
  end
   

   
  def edit
    @article_content = ArticleContent.find(params[:id])
  end
   

   
  def update
    @article_content = ArticleContent.find(params[:id])
    if @article_content.update(article_content_params)
      redirect_to article_content_path(@article_content) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @article_content = ArticleContent.find(params[:id])
    @article_content.destroy
    redirect_to :action => :index
  end
   

  private
    def article_content_params
      params.require(:article_content).permit( :title, :desc, :tag)
    end
  
  
end

