class EventsController < ApplicationController
  def index
    # full_calendar will hit the index method with query parameters
    # 'start' and 'end' in order to filter the results for the
    # appropriate month/week/day.  It should be possiblt to change
    # this to be starts_at and ends_at to match rails conventions.
    # I'll eventually do that to make the demo a little cleaner.
    puts params.inspect
    @event  = Event.new
    @events = Event.scoped  
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    @events.each do |event|
      event.edit_url = edit_event_path(event)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

  def new
    @event = Event.new
    @event.starts_at = params[:dt] unless params[:dt].nil?
  end
  
  def new_OLD
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
    event.studio_id = params[:studio_id]
    puts event.inspect
    event.save!
    
    respond_to do |format|
      format.html ##{ redirect_to @federations }
      format.js 
    end
  end

  def edit
    @event  = Event.find(params[:id])
    @event.edit_url = edit_event_path(@event)
    
    @event = Event.new if @event.nil?
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
      format.js { render @event }
    end
    
    #render :partial => 'events/edit' #, :json => @event 
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @event }
    #  format.js  { 
    #    puts "RENDERING #{@event.title}"
    #    render :partial => 'event_form', :json => @event 
    #    }
    #end
  end

  def create
  end

  def update
    event             = Event.find(params[:id])
    event.title       = params[:event][:title]
    event.starts_at   = params[:event][:starts_at]
    event.ends_at     = params[:event][:ends_at]
    event.description = params[:event][:description]
    event.save!
  end

  def destroy
  end
end
