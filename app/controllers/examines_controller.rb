class ExaminesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  load_and_authorize_resource

   
  def index
    @examines = current_user.examines
  end
   

   
  def show
    @examine = current_user.examines.find(params[:id])
  end

  def drct_org
    gon.leftnodes = []
    archives = current_user.archives
    archives.each do |archive|
      arc_h = Hash.new
      arc_h['name'] = archive.name
      arc_h['drag'] = false 
      arc_arr = []

      portfolios = archive.portfolios
      portfolios.each do |portfolio|
        ptf_h = Hash.new
        ptf_h['name'] = portfolio.name
        ptf_h['drag'] = false
        ptf_arr = []

        file_libs = portfolio.file_libs
        file_libs.each do |file|
          ptf_arr << {'name': file.name, 'drop': false}
        end
        ptf_h['children'] = ptf_arr
        arc_arr << ptf_h
      end
      arc_h['children'] = arc_arr
      gon.leftnodes << arc_h
    end

    gon.rightnodes = []
    @examine = current_user.examines.find(params[:id])
    @exm_items = @examine.exm_items 
    exm_h = Hash.new
    exm_h['name'] = @examine.name
    exm_h['open'] = true
    exm_h['drag'] = false
    exm_h['drop'] = false
    exm_arr = []

    @exm_items.each do |item|
      exm_arr << {'name': item.name, 'drag': false, 'isParent': true}
    end
    exm_h['children'] = exm_arr 
    gon.rightnodes << @examine.hierarchy 
    gon.examine = params[:id]
  end

  def create_drct
    @examine = current_user.examines.find(params[:id])
    drct_data = params[:drct_data]
    if @examine.update_attributes(:hierarchy => drct_data)
      respond_to do |f|
        f.json { render :json => {:status => "保存成功"}.to_json }
      end
    else
      respond_to do |f|
        f.json { render :json => {:status => "保存失败"}.to_json }
      end
    end
  end
   

   
  def new
    @examine = Examine.new
    
    @examine.exm_items.build
    
  end
   

   
  def create
    @examine = Examine.new(examine_params)
    @examine.user = current_user
    if @examine.save
      redirect_to @examine
    else
      render :new
    end
  end
   

   
  def edit
    @examine = current_user.examines.find(params[:id])
  end
   

   
  def update
    @examine = current_user.examines.find(params[:id])
    if @examine.update(examine_params)
      redirect_to examine_path(@examine) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @examine = current_user.examines.find(params[:id])
    @examine.destroy
    redirect_to :action => :index
  end
   

  

  

  private
    def examine_params
      params.require(:examine).permit( :name, exm_items_attributes: exm_item_params)
    end
  
  
  
    def exm_item_params
      [:id, :name ,:_destroy]
    end
  
end
