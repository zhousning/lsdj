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
    docx = Caracal::Document.new(target_folder + '/目录.docx')
    style_config(docx)

    title_level = 0 #判断目录层级用 
    index = 1 #给每个文件编号,包括文件夹
    root_folder = target_folder + "/" + index.to_s + "_" + examine.name
    FileUtils.makedirs(root_folder) unless File.directory?(root_folder)

    hier(objs, target_folder, index, title_level, target_folder, docx)
    docx.save
    command = "zip -r " + target_folder + ".zip " + target_folder
    system(command)
    document.update_attribute :html_link, File.basename(target_folder + ".zip")
  end

  def hier(node, level, index, title_level, target_folder, docx)
    nodeid = node['nodeid']
    name = node['name']
    index_str = index.to_s
    level += "/#{index_str}_#{name}" 
    title_level += 1

    isParent = node['isParent']
    if isParent
      FileUtils.makedirs(level) unless File.directory?(level)

      front_cover_dir = target_folder + "/封皮/" + title_level.to_s + "级封皮"
      front_cover(front_cover_dir, name)

      category(title_level, index_str, name, docx)
    else
      if nodeid
        @file = FileLib.find(nodeid)
        if @file
          FileUtils.cp FOLDER_PUBLIC + @file.path, level
          docx.p "#{index}、#{name}" do 
            style 'p'
          end
        end
      end
    end

    if node['children'] 
      node['children'].each_with_index do |obj, index|
        hier(obj, level, index+1, title_level, target_folder, docx)
      end
    end
  end


  def category(title_level, index, name, docx)
    if title_level == 1
      docx.h1 "#{index} #{name}" 
    elsif title_level == 2 
      docx.page
      docx.h2 "#{number_map(index)}、#{name}" do
        style 'h2'
      end
    elsif title_level == 3
      docx.h3 "（#{number_map(index)}）#{name}" do 
        style 'h3'
      end
    elsif title_level == 4 
      docx.h4 "( #{index} )、#{name}" do 
        style 'h4'
      end
    else
      docx.p "#{index}、#{name}" do 
        style 'p'
      end
    end
  end

  def front_cover(front_cover_dir, name)
    FileUtils.makedirs(front_cover_dir) unless File.directory?(front_cover_dir)
    template = Sablon.template(File.expand_path(FRONT_COVER))
    context = {
      title: name,
      technologies: ["Ruby", "HTML", "ODF"]
    }
    template.render_to_file File.expand_path(front_cover_dir + "/" + name + ".docx"), context
  end

  def style_config(docx)
    docx.style do
      id "h2"
      name "h2"
      font "黑体"
      size 40
      bold true
      italic false
    end
    docx.style do
      id "h3"
      name "h3"
      font "黑体"
      size 36
      bold true
      italic false
    end
    docx.style do
      id "h4"
      name "h4"
      font "黑体"
      size 32
      bold true
      italic false
      indent_left 340
    end
    docx.style do
      id "p"
      name "p"
      font "宋体"
      size 30
      bold false 
      italic false
      indent_left 360
    end
  end

  def number_map(number)
    number = number.to_s
    obj = {
      "1" => "一", 
      "2" => "二", 
      "3" => "三", 
      "4" => "四", 
      "5" => "五"
    }
    obj[number]
  end
end
