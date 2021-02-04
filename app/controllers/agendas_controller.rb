class AgendasController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @agendas = current_user.agendas.order("worktime DESC")
  end
   

   
  def show
    @agenda = current_user.agendas.find(params[:id])
  end
   

   
  def new
    @agenda = Agenda.new
    
  end
   

   
  def create
    @agenda = Agenda.new(agenda_params)
    @agenda.user = current_user
    if @agenda.save
      redirect_to @agenda
    else
      render :new
    end
  end
   

   
  def edit
    @agenda = current_user.agendas.find(params[:id])
  end
   

   
  def update
    @agenda = current_user.agendas.find(params[:id])
    if @agenda.update(agenda_params)
      redirect_to agenda_path(@agenda) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @agenda = current_user.agendas.find(params[:id])
    @agenda.destroy
    redirect_to :action => :index
  end
   

  

  
    def download_append
      @agenda = current_user.agendas.find(params[:id])
      @idattch = @agenda.idattch_url

      if @idattch
        send_file File.join(Rails.root, "public", URI.decode(@idattch)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  private
    def agenda_params
      params.require(:agenda).permit( :title, :content, :worktime , :idattch)
    end
  
  
  
end

