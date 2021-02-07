class PortfoliosController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
  protect_from_forgery :except => :upload

   
  def index
    @archive = current_user.archives.find(params[:archive_id])
    @portfolios = @archive.portfolios
  end
   

   
  def show
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
  end
   

   
  def new
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = Portfolio.new
  end
   

   
  def create
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.archive = @archive 
    if @portfolio.save
      redirect_to archive_portfolios_url(@archive)
    else
      render :new
    end
  end
   

   
  def edit
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
  end
   

   
  def update
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
    if @portfolio.update(portfolio_params)
      redirect_to archive_portfolios_url(@archive)
    else
      render :edit
    end
  end
   

   
  def destroy
    @archive = current_user.archives.find(params[:archive_id])
    @portfolio = @archive.portfolios.find(params[:id])
    @portfolio.destroy
    redirect_to :action => :index
  end
  
  def file_type(name)
    type = ""
    if !(/\.doc/ =~ name).nil?
      type = Setting.file_libs.doc
    elsif !(/\.xls/ =~ name).nil?
      type = Setting.file_libs.xls
    elsif !(/\.ppt/ =~ name).nil?
      type = Setting.file_libs.ppt
    elsif !(/\.pdf/ =~ name).nil?
      type = Setting.file_libs.pdf
    elsif !(/\.jpg|\.png|\.jpeg/ =~ name).nil?
      type = Setting.file_libs.img
    elsif !(/\.mp4/ =~ name).nil?
      type = Setting.file_libs.mp4
    elsif !(/\.txt/ =~ name).nil?
      type = Setting.file_libs.txt
    end
    type
  end

  def upload
    @archive = current_user.archives.find(params[:archive_id])
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
            filetype = file_type(name) 
            @filelib = FileLib.new(:name => name, :path => file_path, :file_type => filetype) 
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

