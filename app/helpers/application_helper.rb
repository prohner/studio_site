module ApplicationHelper
  def site_name
    "Studio Site Support"
  end
  
  def page_name(page_name)
    if  page_name.empty?
      site_name
    else
      site_name + " | " + page_name
    end
      
  end
end
