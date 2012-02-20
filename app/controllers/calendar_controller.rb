class CalendarController < ApplicationController
  def index
    @event = Event.new
  end
  
end
