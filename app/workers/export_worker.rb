require "sablon"

class ExportWorker
  include Sidekiq::Worker

  FOLDER_PUBLIC = File.join(Rails.root, "public")
  FRONT_COVER = File.join(Rails.root, "app", "workers", "templates", "frontcover.docx")

  def perform(examine_id, document_id, name)
    @examine = Examine.find(examine_id)
    @document = Document.find(document_id)
    @document.update_attribute :status, Setting.documents.status_process

    begin
      export_process(@examine, @document, name)
      @document.update_attribute :status, Setting.documents.status_success
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect 
      @document.update_attribute :status, Setting.documents.status_fail
    end
  end

  def export_process(examine, document, name) 
    hierarchy = examine.hierarchy
    objs = JSON.parse(hierarchy)
    target_folder = Rails.root.join("public", "examines", examine.id.to_s, name).to_s

    title_level = 0 #判断目录层级用 
    index = 1 #给每个文件编号,包括文件夹
    hier(objs, target_folder, index, title_level, target_folder)
    command = "zip -r " + target_folder + ".zip " + target_folder
    system(command)
    document.update_attribute :html_link, File.basename(target_folder + ".zip")
  end

  def hier(node, level, index, title_level, target_folder)
    nodeid = node['nodeid']
    name = node['name']
    level += "/#{index.to_s}_#{name}" 
    title_level += 1
    puts level
    

    isParent = node['isParent']
    if isParent
      FileUtils.makedirs(level) unless File.directory?(level)

      front_cover_dir = target_folder + "/封皮/" + title_level.to_s + "级封皮"
      FileUtils.makedirs(front_cover_dir) unless File.directory?(front_cover_dir)

      template = Sablon.template(File.expand_path(FRONT_COVER))
      context = {
        title: name,
        technologies: ["Ruby", "HTML", "ODF"]
      }
      template.render_to_file File.expand_path(front_cover_dir + "/" + name + ".docx"), context
    else
      if nodeid
        @file = FileLib.find(nodeid)
        if @file
          FileUtils.cp FOLDER_PUBLIC + @file.path, level
        end
      end
    end

    if node['children'] 
      node['children'].each_with_index do |obj, index|
        hier(obj, level, index+1, title_level, target_folder)
      end
    end
  end
end
