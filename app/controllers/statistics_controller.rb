class StatisticsController < ApplicationController
  layout "application_control"
  before_action :authenticate_user!

  def index
    @line_title = chart_title("标题", "图例", "x轴标题", "y轴标题", "#007bff")
    @column_title = chart_title("标题", "图例", "x轴标题", "y轴标题", "#e83e8c")
    @bar_title = chart_title("标题", "图例", "x轴标题", "y轴标题", "#28a745")
    @area_title = chart_title("标题", "图例", "x轴标题", "y轴标题", "#fd7e14")
    @scatter_title = chart_title("标题", "图例", "x轴标题", "y轴标题", "#17a2b8")

    @pie_title = chart_title("标题", "图例", "x轴标题", "y轴标题" )
  end
   
  def line
    puts "........"
    puts FileLib.group(:name).count
    render json: FileLib.group(:name).count
  end

  def column
    render json: FileLib.group(:name).count
  end

  def pie 
    render json: FileLib.group(:name).count
  end

  def bar 
    render json: FileLib.group(:name).count
  end

  def area 
    render json: FileLib.group(:name).count
  end

  def scatter 
    render json: FileLib.group(:name).count
  end

  def series 
    #第一个group是序列,第二个group是x轴对应的值
    render json: FileLib.group(:coin).group(:name).count.chart_json
  end

  private
    def chart_title(title, label, xtitle, ytitle, *colors)
      return {
        title: title,
        label: label,
        xtitle: xtitle,
        ytitle: ytitle,
        colors: colors
      }
    end
end

