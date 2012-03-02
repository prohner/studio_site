class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :correct_safari_and_ie_accept_headers
  before_filter :set_timezone
  after_filter :set_xhr_flash

  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end

  def set_timezone
    Time.zone = current_studio.time_zone  if signed_in?
  end
  
  def dates_from_form(event)
    begin
      event.starts_at    = Event.parse_calculator_time(params[:starts_at], "starts_at")
      event.ends_at      = Event.parse_calculator_time(params[:ends_at], "ends_at")
    rescue Exception => e
      if params[:repeating_event].nil?
        event.starts_at    = params[:event][:starts_at]
        event.ends_at      = params[:event][:ends_at]
      else 
        event.starts_at    = params[:repeating_event][:starts_at]
        event.ends_at      = params[:repeating_event][:ends_at]
      end
    end
    event
  end
  
end
