class WebServicesController < ApplicationController
  def studios
    @studios = Studio.find(:all, :order => "name ASC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @studios }
      format.json  { render :json => @studios }
    end
  end

  def events
  end

  def repeating_events
  end

  def terminology
  end
end
