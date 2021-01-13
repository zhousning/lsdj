module TemplatesHelper
  def type_options
    [["string", "string"], ["float", "float"], ["integer", "integer"], ["text", "text"], ["datetime", "datetime"], ["boolean", "boolean"]]
  end

  def options_for_tag 
    [["text", "text"], ["textarea", "textarea"], ["number", "number"], ["phone", "phone"],["date", "date"], ["password", "password"], ["phone", "phone"], ["email", "email"], ["radio", "radio"], ["select","select"]]
  end                                            

  def options_for_type
    [["has_one", "has_one"], ["has_many", "has_many"], ["belongs_to", "belongs_to"]]
  end                                            
end  
