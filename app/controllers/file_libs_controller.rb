class FileLibsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  load_and_authorize_resource

   
  def index
    @archive = Archive.find(params[:archive_id])
    @file_libs = @archive.file_libs
  end
   

   
  def show
    @archive = Archive.find(params[:archive_id])
    @file_lib = @archive.file_libs.find(params[:id])
  end
   

   
  def new
    @file_lib = FileLib.new
    
  end
   

   
  def create
    @archive = Archive.find(params[:archive_id])
    @file_lib = FileLib.new(file_lib_params)
    @file_lib.archive = @archive
    if @file_lib.save
      redirect_to @file_lib
    else
      render :new
    end
  end
   

   
  def edit
    @archive = Archive.find(params[:archive_id])
    @file_lib = @archive.file_libs.find(params[:id])
  end
   

   
  def update
    @archive = Archive.find(params[:archive_id])
    @file_lib = @archive.file_libs.find(params[:id])
    if @file_lib.update(file_lib_params)
      redirect_to file_lib_path(@file_lib) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @archive = Archive.find(params[:archive_id])
    @file_lib = @archive.file_libs.find(params[:id])
    @file_lib.destroy
    redirect_to :action => :index
  end
   


  def download_append
    @file_lib = FileLib.find(params[:id])
    @idattch = @file_lib.idattch_url

    if @idattch
      send_file File.join(Rails.root, "public", URI.decode(@idattch)), :type => "application/force-download", :x_sendfile=>true
    end
  end
  
  

  

  private
    def file_lib_params
      params.require(:file_lib).permit( :name, :path, :file_type)
    end
  
  
  
end

