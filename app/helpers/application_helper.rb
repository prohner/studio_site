module ApplicationHelper
  def site_name
    "Studio Site Support"
  end
  
  def page_name
    if @title.nil? or @title.empty?
      site_name
    else
      "#{site_name} | #{@title}"
    end
  end
  
  def logo
    image_tag("http://www.ifk-germany.de/kyokushin/images/kogakushin.gif", :alt => "Sample App", :class => "round") 
  end
end
