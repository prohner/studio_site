class Event < ActiveRecord::Base
  has_event_calendar
end
# == Schema Information
#
# Table name: events
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

