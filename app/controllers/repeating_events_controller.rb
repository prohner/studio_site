class RepeatingEventsController < ApplicationController
  def index
    @events = []
    @repeating_events = RepeatingEvent.scoped
    @repeating_events = @repeating_events.after(params['start']) if (params['start'])
    @repeating_events = @repeating_events.before(params['end']) if (params['end'])

    @repeating_events.each do |repeater|
      tmp_events = repeater.events_for_timeframe(Time.at(params['start'].to_i), Time.at(params['end'].to_i))
      tmp_events.each do |event|
        event.edit_url = edit_repeating_event_path(repeater)
      end

      @events += tmp_events
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

  def show
  end

  def new
  end

  def edit
    @event  = RepeatingEvent.find(params[:id])
    @event.edit_url = edit_repeating_event_path(@event)
    
    @event = RepeatingEvent.new if @event.nil?
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
      format.js { render @event }
    end
  end

  def create
  end

  def update
    event             = RepeatingEvent.find(params[:id])
    event.title       = params[:repeating_event][:title]

    event.description = params[:repeating_event][:description]
    event.color         = params[:repeating_event][:color]

    if params[:event_start].nil?
      event.starts_at = params[:starts_at]
      event.ends_at   = params[:ends_at]
    else
      i1              = params[:event_start]["starts_at(1i)"]
      i2              = params[:event_start]["starts_at(2i)"]
      i3              = params[:event_start]["starts_at(3i)"]
      i4              = params[:starts_at]["starts_at(4i)"]
      i5              = params[:starts_at]["starts_at(5i)"]
      s               = "#{i1}-#{i2}-#{i3} #{i4}:#{i5}:00"
      event.starts_at = Time.zone.parse(s)

      i1              = params[:event_end]["ends_at(1i)"]
      i2              = params[:event_end]["ends_at(2i)"]
      i3              = params[:event_end]["ends_at(3i)"]
      i4              = params[:ends_at]["ends_at(4i)"]
      i5              = params[:ends_at]["ends_at(5i)"]
      s               = "#{i1}-#{i2}-#{i3} #{i4}:#{i5}:00"
      event.ends_at   = Time.zone.parse(s)
    end

    event.on_monday     = params[:repeating_event][:on_monday]
    event.on_tuesday    = params[:repeating_event][:on_tuesday]
    event.on_wednesday  = params[:repeating_event][:on_wednesday]
    event.on_thursday   = params[:repeating_event][:on_thursday]
    event.on_friday     = params[:repeating_event][:on_friday]
    event.on_saturday   = params[:repeating_event][:on_saturday]
    event.on_sunday     = params[:repeating_event][:on_sunday]
    event.save!

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event }
      format.js { render @event }
    end
  end

  def destroy
    RepeatingEvent.find_by_id(params[:id]).destroy
    flash[:success] = "Event destroyed."
    
    respond_to do |format|
      format.html { redirect_to calendar_index_path }
      format.xml  { head :ok }
      format.js
    end
  end
end
