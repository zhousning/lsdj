class ArticlesController < ApplicationController
  layout "application_control"
  #before_filter :authenticate_user!
  #load_and_authorize_resource

  PUBLIC_FOLDER = File.join(Rails.root, "public")
  ARTICLE_FOLDER = PUBLIC_FOLDER + "/articles/"
   
  def index
    @articles = Article.all
  end
   

   
  def show
    @article = Article.find(params[:id])
  end
   

   
  def new
    @article = Article.new
    
    @article.article_contents.build
    
  end
   

   
  def create
    @article = Article.new(article_params)
    #@article.user = current_user
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end
   

  def edit
    @article = Article.find(params[:id])
  end
   

   
  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to article_path(@article) 
    else
      render :edit
    end
  end
   
  def export
    articles = Article.all
    vxlogo = "lib/tasks/data/coursefolder/assets"
    articles.each do |article|
      folder = ARTICLE_FOLDER + "/" + article.lang + "/"
      FileUtils.mkdir(folder) unless File.directory?(folder)
      unless File.directory?(folder + "assets")
        FileUtils.cp_r(vxlogo, folder) 
        target_file = folder + 'README.md'
        title_one = "<h1>全套最新" + article.lang + "视频教程</h1>" 
        badge = "<img src='https://img.shields.io/badge/download-5.3K-brightgreen'/><a href='assets/vxlogo.jpg'><img src='https://img.shields.io/badge/author-%E6%9D%BE%E9%BC%A0-blue'/></a><img src='https://img.shields.io/badge/licenese-crystal-green'/><br/>"
        intro = "<img src='assets/about.jpg'/><img src='assets/content.jpg'/><img src='assets/route.jpg'/><br/>"
        md = ReverseMarkdown.convert title_one + badge + intro 
        File.open(target_file, 'a+') do |f|
          f.write(md)
        end
      end
      export_articles(article, folder)
      produce_readme(article, folder)
    end
    redirect_to articles_path
  end

  def main_image
    @article = Article.find(params[:id])
    @imgs = @article.enclosures
  end

  def detail_image
    @article = Article.find(params[:id])
  end
   
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :action => :index
  end
   

  private
    def article_params
      params.require(:article).permit( :title, :lang, :vol, :desc, :category, :address , enclosures_attributes: enclosure_params, article_contents_attributes: article_content_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
    def article_content_params
      [:id, :title, :desc, :tag]
    end
  
  def export_articles(article, folder)
    ctns = article.article_contents
    ctg = article.category.gsub("\n", "  \n")
    title = '<h1>' + article.title + '视频教程</h1>'
  
    address = '<blockquote>网盘地址:  ' + article.address + '</blockquote>'
    ctn_str = "<h2>加公众号 获取更多新教程</h2><img src='assets/vxlogo.jpg'/>"
    ctns.each do |ctn|
      ctn_str += '<h2>' + ctn.title + '</h2>'
      ctn_str += '<p>' + ctn.desc.gsub("\r\n", "</p><p>") + '</p>'
    end
    
    ctn_title = '<h2>教程目录大纲</h2>'
    md = ReverseMarkdown.convert title + address + ctn_str + ctn_title
  
    target_file = folder + article.title + '.md'
    File.open(target_file, 'w+') do |f|
      f.write(md + ctg)
    end
  end
  
  def produce_readme(article, folder)
    title = '<h2>' + article.title + '视频教程' + "--" + article.vol + '--<a href="' + article.title + '.md">' + '目录大纲</a>' + '</h2>'
    address = '<blockquote>网盘地址:  ' + article.address + '</blockquote>'
  
    md = ReverseMarkdown.convert title + address 
  
    target_file = folder + 'README.md'
    File.open(target_file, 'a+') do |f|
      f.write(md)
    end
  end
end

