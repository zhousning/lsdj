module NewsitesHelper
  def options_for_newsite_draft_navbar(pages, page)
    str = ""
    pages.each do |item|
      next if item.id == page.id
      if item.id == page.parent_id
        str += "<option selected='selected' value='" + item.id.to_s + "'>" + item.name + "</option>"
      else
        str += "<option value='" + item.id.to_s + "'>" + item.name + "</option>"
      end
    end
    raw(str)
  end
end
