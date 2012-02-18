class RepeatingEvent < ActiveRecord::Base
  belongs_to :studio

  validates :title, 
            :presence   => true,
            :length     => { :maximum => 50 }
  validates :studio_id, :presence => true

  validates_inclusion_of :repetition_type, :in => %w( weekly monthly )
  
  validate :must_have_valid_repetition_info
  validate :starts_at_must_be_before_ends_at
  
  
  def starts_at_must_be_before_ends_at
    unless starts_at.nil? or ends_at.nil?
      if starts_at.utc > ends_at.utc
        errors.add(:starts_at, "Start date must be before end date")
      end
    end
  end

  def must_have_valid_repetition_info
    case repetition_type
    when "weekly"
      if !on_sunday and !on_monday and !on_tuesday and !on_wednesday and !on_thursday and !on_friday and !on_saturday 
        errors.add(:repetition_type, "Need a day along with weekly")
      end
    when "monthly"
      if !on_sunday and !on_monday and !on_tuesday and !on_wednesday and !on_thursday and !on_friday and !on_saturday 
        errors.add(:repetition_type, "Need a day along with monthly")
      end
    end
  end
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
#  repetition_type      :string(255)
#  repetition_frequency :integer
#  on_sunday            :boolean
#  on_monday            :boolean
#  on_tuesday           :boolean
#  on_wednesday         :boolean
#  on_thursday          :boolean
#  on_friday            :boolean
#  on_saturday          :boolean
#  repetition_options   :string(255)
#  studio_id            :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

