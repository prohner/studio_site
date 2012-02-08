class MasterFederation < ActiveRecord::Base
  belongs_to  :master_style
  has_many    :master_term_groups, :dependent => :destroy

  validates :name,
            :presence => true, 
            :length => { :maximum => 250 },
            :uniqueness => { :scope => :master_style_id, :case_sensitive => false }
#            :uniqueness => { :case_sensitive => false }
            
  default_scope :order => 'master_federations.name'
end
# == Schema Information
#
# Table name: master_federations
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  master_style_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

