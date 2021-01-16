class ArchivesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  load_and_authorize_resource
  protect_from_forgery :except => :upload

   
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
      redirect_to @archive
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
      redirect_to archive_path(@archive) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @archive = current_user.archives.find(params[:id])
    @archive.destroy
    redirect_to :action => :index
  end
   

  def upload
    @archive = Archive.find(params[:id])

    uploaded_file = params[:file]
    if @archive
      begin
        folder = Rails.root.join('public', 'uploads', @archive.id.to_s)
        FileUtils.makedirs(folder) unless File.exists?folder
        file_name = folder + uploaded_file.original_filename
        File.open(file_name, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        respond_to do |f|
          f.json { render :json => {:success => "上传成功"}.to_json }
        end
      rescue Exception => e
        puts e
        respond_to do |f|
          f.json { render :json => {:error => e}.to_json }
        end
      end
    else
      respond_to do |f|
        f.json { render :json => {:error => "请求对象不存在"}.to_json }
      end
    end
  end
  

  private
    def archive_params
      params.require(:archive).permit( :name, :desc)
    end
  
  
  
end

