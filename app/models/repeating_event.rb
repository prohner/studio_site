class RepeatingEvent < ActiveRecord::Base
  belongs_to :studio

  validates :title, 
            :presence   => true,
            :length     => { :maximum => 50 }
  validates :studio_id, :presence => true
end
# == Schema Information
#
# Table name: repeating_events
#
#  id                   :integer         not null, primary key
#  title                :string(255)
#  starts_at            :datetime
#  ends_at              :datetime
#  all_day              :boolean
#  description          :text
#  repetition_frequency :integer
#  repetition_options   :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  studio_id            :integer
#

