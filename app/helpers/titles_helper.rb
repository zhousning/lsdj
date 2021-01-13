module TitlesHelper

  def options_for_title_tag 
    convert_config_to_options(Setting.tags)
  end                                            

  def options_for_align
    convert_config_to_options(Setting.aligns)
  end                                            

  def options_for_layout
    convert_config_to_options(Setting.block_layouts)
  end                                            

  def options_for_color
    convert_config_to_options(Setting.colors)
  end                                            

  def options_for_color_arr
    convert_config_to_arr_options(Setting.colors)
  end                                            

  def options_for_font
    convert_config_to_options(Setting.fonts)
  end                                            

  def options_for_website_color
    convert_config_to_options(Setting.website_colors)
  end                                            

  def options_for_website_style
    convert_config_to_options(Setting.website_styles)
  end                                            

  def options_for_color_style
    convert_config_to_options(Setting.color_styles)
  end                                            

  def options_for_background
    convert_config_to_options(Setting.bgs)
  end                                            

  def options_for_weight
    convert_config_to_options(Setting.weights)
  end                                            

  def options_for_line_height
    convert_config_to_options(Setting.line_heights)
  end                                            

  def options_for_letter_spacing
    convert_config_to_options(Setting.letter_spacings)
  end                                            

  def options_for_subunit
    options = Hash.new
    Subunit.all.each do |u|
      options[u.name] = u.id
    end
    options
  end

  def options_for_subunit_type
    convert_config_to_options(Setting.subunit_types)
  end

  def options_for_subunit_type
    convert_config_to_options(Setting.subunit_types)
  end

  def options_for_subunit_icon_type
    convert_config_to_options(Setting.subunit_icon_types)
  end

  def options_for_subunit_navbar
    options = Hash.new
    subunits = Subunit.where(:category => Setting.subunit_types.navbar.value)
    subunits.each do |u|
      options[u.name] = u.id
    end
    options
  end

  def options_for_subunit_mastheader
    options = Hash.new
    subunits = Subunit.where(:category => Setting.subunit_types.mastheader.value)
    subunits.each do |u|
      options[u.name] = u.id
    end
    options
  end

  def options_for_subunit_footer
    options = Hash.new
    subunits = Subunit.where(:category => Setting.subunit_types.footer.value)
    subunits.each do |u|
      options[u.name] = u.id
    end
    options
  end

  def options_for_subunit_block
    options = Hash.new
    subunits = Subunit.where(:category => Setting.subunit_types.section.value)
    subunits.each do |u|
      options[u.name] = u.id
    end
    options
  end
  private

    def convert_config_to_options(obj)
      options = Hash.new
      obj.to_h.each_value do|result|
        options[result["info"]] = result["value"]
      end
      options
    end

    def convert_config_to_arr_options(obj)
      result = []
      obj.to_h.each_value do|item|
        arr = []
        arr << '图标颜色' 
        arr << item["value"]
        arr << { class: item["info"]}
        result << arr
      end
      result
    end
end  
