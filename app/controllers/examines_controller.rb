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

