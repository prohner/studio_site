class CalendarController < ApplicationController
  def index
    @styles = MasterStyle.all
    
    @styles << MasterStyle.new(:name => 'Last', :created_at => '2/9/2012 23:59')
    @styles << MasterStyle.new(:name => 'First', :created_at => '2/9/2012 00:01')
  end
end
