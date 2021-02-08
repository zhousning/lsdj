class MeterStandardsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  #def index
  #  @meter_standards = MeterStandard.all
  #end
   

   
  def show
    @meter_standard = MeterStandard.find(params[:id])
  end
   

   
  #def new
  #  @meter_standard = MeterStandard.new
  #  
  #end
  # 

  # 
  #def create
  #  @meter_standard = MeterStandard.new(meter_standard_params)
  #  #@meter_standard.user = current_user
  #  if @meter_standard.save
  #    redirect_to @meter_standard
  #  else
  #    render :new
  #  end
  #end
   

   
  def edit
    @meter_standard = current_user.meter_standard
  end
   

   
  def update
    @meter_standard = MeterStandard.find(params[:id])
    if @meter_standard.update(meter_standard_params)
      redirect_to edit_meter_standard_path(@meter_standard) 
    else
      render :edit
    end
  end
   

   
  #def destroy
  #  @meter_standard = MeterStandard.find(params[:id])
  #  @meter_standard.destroy
  #  redirect_to :action => :index
  #end
   

  

  

  private
    def meter_standard_params
      params.require(:meter_standard).permit( :std_sm_wm, :std_big_wm, :std_sm_yc, :std_big_yc, :std_vst_wm, :cj_jl, :cj_cf, :yd_jl, :ydzj_jl, :ed_jl, :edzj_jl, :yd_cf, :ed_cf, :sd_cf, :zg_cf)
    end
  
  
  
end

