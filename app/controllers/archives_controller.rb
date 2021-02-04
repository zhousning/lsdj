class ArchivesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @archives = current_user.archives
  end
   

   
  def show
    @archive = current_user.archives.find(params[:id])
  end
   

   
  def new
    @archive = Archive.new
    
  end
   

   
  def create
    @archive = Archive.new(archive_params)
    @archive.user = current_user
    if @archive.save
      redirect_to archives_url
    else
      render :new
    end
  end
   

   
  def edit
    @archive = current_user.archives.find(params[:id])
  end
   

   
  def update
    @archive = current_user.archives.find(params[:id])
    if @archive.update(archive_params)
      #redirect_to archive_path(@archive) 
      redirect_to archives_url
    else
      render :edit
    end
  end
   

   
  def destroy
    @archive = current_user.archives.find(params[:id])
    @archive.destroy
    redirect_to :action => :index
  end
   

  private
    def archive_params
      params.require(:archive).permit( :name, :desc)
    end
  
  
  
end

