class Event < ActiveRecord::Base
  belongs_to :studio
  
  attr_accessor :edit_url
  attr_accessible :studio, :studio_id, :title, :description, :starts_at, :ends_at, :all_day, :color
  
  scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Event.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Event.format_date(start_time)] }}
  scope :studio_id, lambda {|studio_id| {:conditions => ["studio_id = ?", studio_id] }}

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
      :start => self.starts_at,#.rfc822,
      :end => self.ends_at,#.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :color => self.color.nil? ? "blue" : self.color,
      :url => self.edit_url #Rails.application.routes.url_helpers.edit_event_path(id)
    }
  end
  
  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
  
  def self.parse_calculator_time(hash, tag_name)
    t1 = hash["#{tag_name}(1i)"]
    t2 = hash["#{tag_name}(2i)"]
    t3 = hash["#{tag_name}(3i)"]
    t4 = hash["#{tag_name}(4i)"]
    t5 = hash["#{tag_name}(5i)"]
    s = "#{t1}-#{t2}-#{t3} #{t4}:#{t5}:00"
    #puts "#{s} ==> #{Time.parse(s)}"
    Time.zone.parse(s)
  end
  
  def self.HTML_color_names
    { "red"           => "Red",
      "green"         => "Green",
      "blue"          => "Blue",
      "darkorchid"    => "Dark Orchid",
      "darkgoldenrod" => "Dark Golden Rod",
      "aqua"          => "Aqua",
      "fuchsia"       => "Fuchsia"
      }
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
#  color       :string(255)
#

