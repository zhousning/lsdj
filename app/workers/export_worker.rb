class ExportWorker
  include Sidekiq::Worker
  include TitlesHelper

  PUBLIC_FOLDER = File.join(Rails.root, "public")
  SOURCE_FOLDER = File.join(Rails.root, "app", "workers", "templates", "source")
  WEBSITE_FOLDER = PUBLIC_FOLDER + "/websites/"
  CSS_ERB = File.join(Rails.root, "app", "workers", "templates", "css.html.erb")
  JS_ERB = File.join(Rails.root, "app", "workers", "templates", "js.html.erb")
  ERB_ERB = File.join(Rails.root, "app", "workers", "templates", "erb.html.erb")


  #navbar mastheader block footer
  def perform(website_id, document_id)
    FileUtils.mkdir(WEBSITE_FOLDER) unless File.directory?(WEBSITE_FOLDER)
    @website = Website.find(website_id)
    @document = Document.find(document_id)
    @document.update_attribute :status, Setting.documents.status_process

    begin
      export_to_erb(@website, @document)
      export_to_html(@website, @document)
      @document.update_attribute :status, Setting.documents.status_success
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect 
      @document.update_attribute :status, Setting.documents.status_fail
    end
  end

  def export_to_erb(website, document)
    number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    website_erb_dir = Pinyin.t(website.name, splitter: '') + number
    erb_template_dir = File.join(Rails.root, "public", "erb_templates", website_erb_dir, number)
    FileUtils.makedirs(erb_template_dir) unless File.exists?erb_template_dir

    @navbar = website.navbar.blank? ? nil :  Subunit.find(website.navbar)
    @footer = website.footer.blank? ? nil :  Subunit.find(website.footer)

    pages = website.pages
    pages.each do |page|
      @mastheader = page.mastheader.blank? ? nil :  Subunit.find(page.mastheader)
      @blocks = page.blocks
      erb_str = File.read(ERB_ERB)
      renderer = ERB.new(erb_str)
      result = renderer.result(binding)
      erb_file = Pinyin.t(page.name, splitter: '') + ".html.erb"
      target_file = erb_template_dir + "/" + erb_file
      File.open(target_file, 'w+') do |f|
        f.write(result)
      end
      erb_file = "/" + website_erb_dir + "/" + number + "/" + erb_file
      page.add_erb(erb_file)
    end
    command = "zip -r " + erb_template_dir + ".zip " + erb_template_dir
    system(command)
    document.update_attribute :erb_link, File.basename(erb_template_dir + ".zip")
  end

  def export_to_html(website, document) 
    number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    @target_folder = WEBSITE_FOLDER + number
    FileUtils.makedirs([@target_folder + "/stylesheets/", @target_folder + "/javascripts/"])

    pages = website.pages
    @menus = pages.where(:parent_id => nil)
    @logo = website.logo_url

    pages.each do |page|
      @file_name = Pinyin.t(page.name, splitter: '')
      @blocks = page.blocks
      @carousels = page.carousels 
      @mastheader = page.mastheader.blank? ? nil :  Subunit.find(page.mastheader)

      set_icon_image(website, @blocks)

      target_html = @target_folder + "/" + @file_name + ".html"
      html_erb = File.read(File.join(Rails.root, "public", "erb_templates") + page.erb_file)
      html_renderer = ERB.new(html_erb)
      html_result = html_renderer.result(binding)
      File.open(target_html, 'w+') do |f|
        f.write(html_result)
      end

      subunit_arr = []
      @blocks.each do |block|
        subunit_arr << block.subunit
      end
      subunit_arr.uniq!
      @subunits = Subunit.find(subunit_arr)
      
      target_css = @target_folder + "/stylesheets/" + @file_name + ".css"
      css_erb = File.read(CSS_ERB)
      css_renderer = ERB.new(css_erb)
      css_result = css_renderer.result(binding)
      File.open(target_css, 'w+') do |f|
        f.write(css_result)
      end

      target_js = @target_folder + "/javascripts/" + @file_name + ".js"
      js_erb = File.read(JS_ERB)
      js_renderer = ERB.new(js_erb)
      js_result = js_renderer.result(binding)
      File.open(target_js, 'w+') do |f|
        f.write(js_result)
      end
    end

    copy_file(website, @target_folder)
    command = "zip -r " + @target_folder + ".zip " + @target_folder
    system(command)
    document.update_attribute :html_link, File.basename(@target_folder + ".zip")
  end

  def copy_file(website, target_folder)

    FileUtils.cp_r [SOURCE_FOLDER + "/stylesheets", SOURCE_FOLDER + "/javascripts", SOURCE_FOLDER + "/assets"], target_folder

    target_assets_folder = target_folder + "/assets/" 

    image_arr = []

    copy_enclosures(image_arr, website.logo_url)

    website.pages.each do |page|
      page.carousels.each do |c|
        copy_enclosures(image_arr, c.file_url)
      end

      blocks = page.blocks
      blocks.each do |block|
        block.block_contents.each do |content|
          copy_enclosures(image_arr, content.file_url)
          copy_enclosures(image_arr, content.image) unless content.image.blank?
        end
      end
    end
    FileUtils.cp image_arr, target_assets_folder
  end

  def copy_enclosures(image_arr, file)
    image_arr <<  PUBLIC_FOLDER + file if file
  end

  def set_icon_image(website, blocks)
    color = website.color
    style = '' 
    if website.style == Setting.website_styles.gradient.value
      style = Setting.color_styles.gradient.value 
    else
      style = Setting.color_styles.pure.value 
    end

    blocks.each do |block|
      contents = block.block_contents

      #color_id_arr = ColorLibrary.where(:category => color, :style => style).pluck(:id).sample(1)
      #block_color = ColorLibrary.where(:id => color_id_arr).first
      #icon_style = icon_color(style, block_color)

      line_icon_id_arr = IconLibrary.where(:icon_type => Setting.icon_libraries.line_type).pluck(:id).sample(contents.size)
      line_icons = IconLibrary.where(:id => line_icon_id_arr)

      area_icon_id_arr = IconLibrary.where(:icon_type => Setting.icon_libraries.area_type).pluck(:id).sample(contents.size)
      area_icons = IconLibrary.where(:id => area_icon_id_arr)

      contents.each_with_index do |content, index|
        #HardWorker.perform_async(block_color, content.id) if content.image.blank?
        if content.image.blank?
          image = ImageLibrary.all.sample(1)[0] 
          content.add_image(image.file_name)
        end
        if content.area_icon.blank? ||  content.line_icon.blank? || block.reset_icon
          #icon = icon_str(0, block_icons[index].file_name, icon_style)
          line_icon = icon_str(0, line_icons[index].file_name, '')
          area_icon = icon_str(0, area_icons[index].file_name, '')
          content.add_icon(line_icon, area_icon)
        end
      end
    end
  end

  def icon_color(style, block_color)
    icon_style = ""
    if style = Setting.website_styles.gradient.value
      icon_style = "background: -webkit-linear-gradient(" + block_color.color_value + ");" + "background: linear-gradient(" + block_color.color_value + ");-webkit-background-clip: text;-webkit-text-fill-color: transparent;" 
    else
      icon_style = "color:" + block_color.color_value
    #elsif style = setting.website_styles.pure.value
    #  icon_style = "color:" + block_color.color_value
    #elsif style = Setting.website_styles.flat.value
    #  icon_style = "color:" + block_color.color_value
    #elsif style = Setting.website_styles.sugar.value
    #  icon_style = "color:" + block_color.color_value
    end
    icon_style
  end

  def icon_str(number, icon, style)
    result = ""
    icon_square = '
      <span class="fa-stack fa-3x">
        <i class="fa fa-square fa-stack-2x" style="' + style +'"></i>'
    icon_circle = '
      <span class="fa-stack fa-3x">
        <i class="fa fa-circle fa-stack-2x" style="' + style +'"></i>'
    icon_square_o = '
      <span class="fa-stack fa-3x">
        <i class="fa fa-square-o fa-stack-2x" style="' + style +'"></i>'
    if number == 0
      icon_none = 'fa fa-' + icon 
      result = icon_none
    elsif number == 1 
      icon_square += '<i class="fa fa-' + icon + ' fa-stack-1x fa-inverse" style="' + style +'"></i></span>'
      result = icon_square
    elsif number == 2
      icon_circle += '<i class="fa fa-' + icon + ' fa-stack-1x fa-inverse" style="' + style +'"></i></span>'
      result = icon_circle
    else
      icon_square_o += '<i class="fa fa-' + icon + ' fa-stack-1x" style="' + style +'"></i></span>'
      result = icon_square_o
    end
    result
  end

end
