class StatisticsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @statistics = current_user.statistics.all
  end
   

   
  def show
    @statistic = current_user.statistics.find(params[:id])
    bar_title(@statistic)
  end
   

   
  def new
    @statistic = Statistic.new
    
  end
   

   
  def create
    @statistic = Statistic.new(statistic_params)
    @statistic.user = current_user
    if @statistic.save
      redirect_to @statistic
    else
      render :new
    end
  end
   

   
  def edit
    @statistic = current_user.statistics.find(params[:id])
  end
   

   
  def update
    @statistic = current_user.statistics.find(params[:id])
    if @statistic.update(statistic_params)
      redirect_to statistic_path(@statistic) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @statistic = current_user.statistics.find(params[:id])
    @statistic.destroy
    redirect_to :action => :index
  end

  def bar_title(statistic) 
    @line_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle, "#007bff")
    @column_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle, "#e83e8c")
    @bar_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle, "#28a745")
    @area_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle, "#fd7e14")
    @scatter_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle, "#17a2b8")

    @pie_title = chart_title(statistic.title, statistic.legend, statistic.xtitle, statistic.ytitle )
  end
   
  def line
    result = prepare_data
    render json: result 
  end

  def column
    result = prepare_data
    render json: result 
  end

  def pie 
    result = prepare_data
    render json: result 
  end

  def bar 
    result = prepare_data
    render json: result 
  end

  def area 
    result = prepare_data
    render json: result 
  end

  def scatter 
    result = prepare_data
    render json: result 
  end

  def series 
    #第一个group是序列,第二个group是x轴对应的值
    render json: FileLib.group(:coin).group(:name).count.chart_json
  end

  private
    def statistic_params
      params.require(:statistic).permit( :title, :xtitle, :ytitle, :legend, :data)
    end
  
    def chart_title(title, label, xtitle, ytitle, *colors)
      return {
        title: title,
        label: label,
        xtitle: xtitle,
        ytitle: ytitle,
        colors: colors
      }
    end

    def prepare_data
      @statistic = current_user.statistics.find(params[:id])
      statc_data = @statistic.data
      datas = statc_data.split(/,|，/)
      result = Hash.new
      datas.each do |data|
        next if data.blank?
        data_arr = data.split("=")      
        result[data_arr[0]] = data_arr[1]
      end
      result
    end
  
  
end

