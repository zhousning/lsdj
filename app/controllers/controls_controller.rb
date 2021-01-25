class ControlsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!

  def index
    @agendas = current_user.agendas
    gon.events = []
    @agendas.each do |agenda|
      obj = Hash.new
      obj['title'] = agenda.title
      obj['start'] = agenda.worktime
      obj['url'] = agenda_path(agenda.id)
      gon.events << obj 
    end
  end
end
