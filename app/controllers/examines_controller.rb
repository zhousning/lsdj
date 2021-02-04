require 'json'

class ExaminesController < ApplicationController
  protect_from_forgery :except => :create_drct

  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
   
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
      redirect_to examines_path
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
      redirect_to examines_path
    else
      render :edit
    end
  end
   
  def destroy
    @examine = current_user.examines.find(params[:id])
    @examine.destroy
    redirect_to :action => :index
  end

  def drct_org
    gon.leftnodes = []
    archives = current_user.archives
    archives.each do |archive|
      arc_h = Hash.new
      arc_h['name'] = archive.name
      arc_h['drag'] = false 
      arc_h['open'] = true 
      arc_arr = []

      portfolios = archive.portfolios
      portfolios.each do |portfolio|
        ptf_h = Hash.new
        ptf_h['name'] = portfolio.name
        ptf_h['drag'] = false
        ptf_h['open'] = true 
        ptf_arr = []

        file_libs = portfolio.file_libs
        file_libs.each do |file|
          ptf_arr << {'name': file.name, 'nodeid': file.id}
        end
        ptf_h['children'] = ptf_arr
        arc_arr << ptf_h
      end
      arc_h['children'] = arc_arr
      gon.leftnodes << arc_h
    end

    @examine = current_user.examines.find(params[:id])
    hercy = @examine.hierarchy
    gon.rightnodes = hercy.blank? ? '{"name": "' + @examine.name + '", "isParent": true, "nodeid": null}' : hercy
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
   
  def export
    @examine = current_user.examines.find(params[:id])
    number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    @document = Document.new(:examine => @examine, :title => number, :status => Setting.documents.status_none)
    if @document.save
      ExportWorker.perform_async(@examine.id, @document.id, number)
      redirect_to examine_documents_path(@examine)
    else
      redirect_to :back
    end
  end

  private
    def examine_params
      params.require(:examine).permit( :name, exm_items_attributes: exm_item_params)
    end
  
  
  
    def exm_item_params
      [:id, :name ,:_destroy]
    end
  
end

