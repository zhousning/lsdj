class ExmItemsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
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
    @examine = current_user.examines.find(params[:examine_id])
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
    gon.rightnodes << exm_h 
  end
   

   
  def show
    @exm_item = ExmItem.find(params[:id])
  end
   

   
  def new
    @exm_item = ExmItem.new
    
  end
   

   
  def create
    @exm_item = ExmItem.new(exm_item_params)
    #@exm_item.user = current_user
    if @exm_item.save
      redirect_to @exm_item
    else
      render :new
    end
  end
   

   
  def edit
    @exm_item = ExmItem.find(params[:id])
  end
   

   
  def update
    @exm_item = ExmItem.find(params[:id])
    if @exm_item.update(exm_item_params)
      redirect_to exm_item_path(@exm_item) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @exm_item = ExmItem.find(params[:id])
    @exm_item.destroy
    redirect_to :action => :index
  end
   

  

  

  private
    def exm_item_params
      params.require(:exm_item).permit( :name, :hierarchy)
    end
  
  
  
end

