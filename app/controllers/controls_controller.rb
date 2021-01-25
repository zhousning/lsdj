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
      unless agenda.idattch.blank?
        obj['url'] = download_append_agenda_path(agenda.id)
      end
      gon.events << obj 
    end
  end
end
