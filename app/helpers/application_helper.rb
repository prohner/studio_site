module ApplicationHelper
  def site_name
    "Studio Site Support"
  end
  
  def page_name
    if @title.empty?
      site_name
    else
      "#{site_name} | #{@title}"
    end
      
  end
end
