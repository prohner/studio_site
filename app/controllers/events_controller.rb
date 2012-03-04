class EventsController < ApplicationController
  def index
    # full_calendar will hit the index method with query parameters
    # 'start' and 'end' in order to filter the results for the
    # appropriate month/week/day.  It should be possiblt to change
    # this to be starts_at and ends_at to match rails conventions.
    # I'll eventually do that to make the demo a little cleaner.
    #puts params.inspect
    
    studio_id = params[:id] || current_studio.id
    #puts "request.url=#{request.url}"
    #puts "studio_id = #{studio_id}, params['id'] = #{params[:id]}, current_studio = #{current_studio}"
    
    raise ActionController::RoutingError.new("Studio missing") if studio_id.blank? || Studio.find(studio_id).nil?
    
    @event  = Event.new
    @events = Event.scoped  
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    @events = @events.studio_id(studio_id) if (studio_id)
    
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
    @event            = Event.new
    @event.starts_at  = Time.parse("#{params[:dt]} 09:00 am") unless params[:dt].nil?
    @event.ends_at    = Time.parse("#{params[:dt]} 10:00 am") unless params[:dt].nil?
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
    
  end

  def create
    if signed_in?
      event = Event.new
      event.studio_id   = current_studio.id
      event.title       = params[:event][:title]
      event.description = params[:event][:description]
      event.all_day     = params[:event][:all_day]

      event              = dates_from_form(event)

      puts "event.starts_at==#{event.starts_at}"
      puts "event.ends_at==#{event.ends_at}"
      event.save!
    else
      redirect_to(root_path) 
    end
  end

  def update
    puts params.inspect
    @event              = Event.find(params[:id])
    @event.title        = params[:event][:title]
    @event.description  = params[:event][:description]
    @event.color        = params[:event][:color]
    @event.all_day      = params[:event][:all_day]

    @event              = dates_from_form(@event)

    puts "#{@event.title} goes from #{@event.starts_at} to #{@event.ends_at}"
    @event.save!
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
      format.js #{ render @event }
    end

  end

  def destroy
  end
  
end
