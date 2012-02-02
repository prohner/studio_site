class Style < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :studio
  
  validates :name,      :presence => true, :length => { :maximum => 50 }
  validates :studio_id, :presence => true
  
  default_scope :order => 'styles.name'
end
