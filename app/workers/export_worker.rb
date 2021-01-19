class ExportWorker
  include Sidekiq::Worker

  def perform(examine_id, document_id)
    @examine = Examine.find(examine_id)
    @document = Document.find(document_id)
    @document.update_attribute :status, Setting.documents.status_process

    begin
      export_process(@examine, @document)
      @document.update_attribute :status, Setting.documents.status_success
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect 
      @document.update_attribute :status, Setting.documents.status_fail
    end
  end

  def export_process(examine, document) 
    hierarchy = examine.hierarchy
    objs = JSON.parse(hierarchy)
    number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    level = Rails.root.join("public", "examines", examine.id.to_s, number).to_s

    hier(objs, level)
    command = "zip -r " + level + ".zip " + level
    system(command)
    document.update_attribute :html_link, File.basename(@target_folder + ".zip")
  end

  def hier(node, level)
    nodeid = node['nodeid']
    name = node['name']
    level += "/#{name}" 
    puts level

    isParent = node['isParent']
    if isParent
      FileUtils.makedirs(level) unless File.directory?(level)
    else
      if nodeid
        @file = FileLib.find(nodeid)
        if @file
          FileUtils.cp FOLDER_PUBLIC + @file.path, level
        end
      end
    end

    if node['children'] 
      node['children'].each do |obj|
        hier(obj, level)
      end
    end
  end

end
