class FileLibsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @portfolio = Portfolio.find(params[:portfolio_id])
    @archive = @portfolio.archive
    @file_libs = @portfolio.file_libs
    gon.portfolio = @portfolio.id
  end
   

   
  def show
    @portfolio = Portfolio.find(params[:portfolio_id])
    @file_lib = @portfolio.file_libs.find(params[:id])
  end
   

   
  def new
    @file_lib = FileLib.new
    
  end
   

   
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @file_lib = FileLib.new(file_lib_params)
    @file_lib.portfolio = @portfolio
    if @file_lib.save
      redirect_to @file_lib
    else
      render :new
    end
  end
   

   
  def edit
    @portfolio = Portfolio.find(params[:portfolio_id])
    @file_lib = @portfolio.file_libs.find(params[:id])
  end
   

   
  def update
    @portfolio = Portfolio.find(params[:portfolio_id])
    @file_lib = @portfolio.file_libs.find(params[:id])
    if @file_lib.update(file_lib_params)
      redirect_to file_lib_path(@file_lib) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
    @file_lib = @portfolio.file_libs.find(params[:id])
    @file_lib.destroy
    redirect_to :action => :index
  end
   

  def download
    @file_lib = FileLib.find(params[:id])

    if @file_lib 
      send_file File.join(Rails.root, "public", @file_lib.path), :type => "application/force-download", :x_sendfile=>true
    end
  end
  
  

  

  private
    def file_lib_params
      params.require(:file_lib).permit( :name, :path, :file_type)
    end
  
  
  
end

