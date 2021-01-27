class PortfoliosController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  load_and_authorize_resource
  protect_from_forgery :except => :upload

   
  def index
    @archive = Archive.find(params[:archive_id])
    @portfolios = @archive.portfolios
  end
   

   
  def show
    @archive = Archive.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
  end
   

   
  def new
    @archive = Archive.find(params[:archive_id])
    @portfolio = Portfolio.new
  end
   

   
  def create
    @archive = Archive.find(params[:archive_id])
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.archive = @archive 
    if @portfolio.save
      redirect_to archive_portfolios_url(@archive)
    else
      render :new
    end
  end
   

   
  def edit
    @archive = Archive.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
  end
   

   
  def update
    @archive = Archive.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
    if @portfolio.update(portfolio_params)
      redirect_to archive_portfolios_url(@archive)
    else
      render :edit
    end
  end
   

   
  def destroy
    @archive = Archive.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
    @portfolio.destroy
    redirect_to :action => :index
  end
  

  def upload
    @archive = Archive.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])

    uploaded_file = params[:file]
    if @portfolio
      begin
        folder = Rails.root.join('public', 'uploads', @archive.id.to_s, @portfolio.id.to_s)
        FileUtils.makedirs(folder) unless File.exists?folder

        name = uploaded_file.original_filename
        path_name = folder + name 
        file_path = '/uploads/' + @archive.id.to_s + "/" + @portfolio.id.to_s + "/" + name

        File.open(path_name, 'wb') do |file|
          file.write(uploaded_file.read)
          filelib = @portfolio.file_libs.where(:path => file_path) 
          if filelib.blank?
            @filelib = FileLib.new(:name => name, :path => file_path) 
            @filelib.portfolio = @portfolio
            @filelib.save!
          end
        end
        respond_to do |f|
          f.json { render :json => {:success => "上传成功"}.to_json }
        end
    rescue Exception => e
        puts e
        respond_to do |f|
          f.json { render :json => {:error => "上传失败"}.to_json }
        end
      end
    else
      respond_to do |f|
        f.json { render :json => {:error => "请求对象不存在"}.to_json }
      end
    end
  end
  


  private
    def portfolio_params
      params.require(:portfolio).permit( :name)
    end
  
  
  
end

