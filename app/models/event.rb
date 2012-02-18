class Event < ActiveRecord::Base
  belongs_to :studio
  
  scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Event.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Event.format_date(start_time)] }}

  validates :title, 
            :presence   => true,
            :length     => { :maximum => 50 }
  validates :studio_id, :presence => true
  validates :starts_at, 
            :presence   => true
  validates :ends_at, 
            :presence   => true
  
  validate :starts_at_must_be_before_ends_at
  
  def starts_at_must_be_before_ends_at
    unless starts_at.nil? or ends_at.nil?
      if starts_at.utc > ends_at.utc
        errors.add(:starts_at, "Start date must be before end date")
      end
    end
  end

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => self.starts_at.rfc822,
      :end => self.ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.event_path(id)
    }
  end
  
  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
end
# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  starts_at   :datetime
#  ends_at     :datetime
#  all_day     :boolean
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  studio_id   :integer
#

