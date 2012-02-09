class MasterStyle < ActiveRecord::Base
  has_many :master_federations, :dependent => :destroy
  
  validates :name,
            :presence => true, 
            :length => { :maximum => 50 },
            :uniqueness => { :case_sensitive => false }
            
  default_scope :order => 'master_styles.name'
end
# == Schema Information
#
# Table name: master_styles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

