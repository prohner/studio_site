class WebServicesController < ApplicationController
  def studios
    @studios = Studio.find(:all, :order => "name ASC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @studios, :only => [:id, :name, :address] }
    end
  end

  def studio
    @studio = Studio.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @studio, :include => :styles, :except => [:salt, :encrypted_password, :updated_at, :created_at, :admin, :time_zone, :data] }
    end
  end
  
  def events
    @studio = Studio.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @studio.events.where('starts_at > ?', DateTime.now), :except => [:created_at, :updated_at, :studio_id] }
    end
  end

  def repeating_events
    @studio = Studio.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @studio.repeating_events.where('ends_at > ?', DateTime.now), :except => [:created_at, :updated_at, :studio_id] }
    end
  end

  def terminology
    style = Style.find(params[:id])
    @term_groups = style.term_groups
    
    respond_to do |format|
      format.html # index.html.erb
      format.json  { 
        render :json => @term_groups, 
        :include => [ :terms => { :except => [:updated_at, :created_at, :data] } ],
        :except => [:updated_at, :created_at] }
    end
  end
end
