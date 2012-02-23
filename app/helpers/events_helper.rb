module EventsHelper
  def calendar_date_header(date)
    return "No date" if date.nil?
    
    if date.to_date == Date.today
      s = "Today"
    else
      s = date.strftime("%a")
    end
    
    s += ", " + date.strftime("%b %d, %Y")
  end
end
