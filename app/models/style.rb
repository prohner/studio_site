class Style < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :studio
  has_many :term_groups, :dependent => :destroy
  
  validates :name,      :presence => true, :length => { :maximum => 50 }
  validates :studio_id, :presence => true
  
  default_scope :order => 'styles.name'
end
# == Schema Information
#
# Table name: styles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  studio_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

