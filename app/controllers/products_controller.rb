class ProductsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  load_and_authorize_resource
  protect_from_forgery :except => :upload


   
  def index
    @products = Product.all
  end
   

   
  def show
    @product = Product.find(params[:id])
  end
   

   
  def new
    @product = Product.new
    
  end
   

   
  def create
    @product = Product.new(product_params)
    #@product.user = current_user
    if @product.save
      redirect_to @product
    else
      render :new
    end
  end
   

   
  def edit
    @product = Product.find(params[:id])
  end
   

   
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to :action => :index
  end
   

  def upload
    uploaded_file = params[:file]
    id = params[:id]
    @product = Product.find(id)
    if @product
      begin
        folder = Rails.root.join('public', 'uploads', id)
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
  #uploader = AttachmentUploader.new
  #uploader.store!(uploaded_file)

  

  
    def download_append
      @product = Product.find(params[:id])
      @idattch = @product.idattch_url

      if @idattch
        send_file File.join(Rails.root, "public", URI.decode(@idattch)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  private
    def product_params
      params.require(:product).permit( :name , :picture, {idattch: []})
    end
  
  
  
end

