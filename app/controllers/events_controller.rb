class EventsController < ApplicationController
  def index
    # full_calendar will hit the index method with query parameters
    # 'start' and 'end' in order to filter the results for the
    # appropriate month/week/day.  It should be possiblt to change
    # this to be starts_at and ends_at to match rails conventions.
    # I'll eventually do that to make the demo a little cleaner.
    @events = Event.scoped  
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

  def show
  end

  def new
    puts params.inspect
    if params[:calendar][:id] == ""
      event = Event.new(:title => params[:class_name],
                        :description => params[:class_description],
                        :starts_at => params[:calendar][:the_working_day])
    else
      event = Event.find(params[:calendar][:id])
      event.title = params[:class_name]
      event.description = params[:class_description]
      event.starts_at = params[:calendar][:the_working_day]
    end
    event.ends_at = (event.starts_at + 1.hours).to_datetime
    puts event
    event.save!
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js 
    end
  end

  def edit
  end

  def create
  end

  def update
    event             = Event.find(params[:id])
    event.starts_at   = params[:event][:starts_at]
    event.ends_at     = params[:event][:ends_at]
    event.description = params[:event][:description]
    event.save!
  end

  def destroy
  end
end