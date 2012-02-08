class MasterTermGroup < ActiveRecord::Base
  belongs_to  :master_federation
  has_many    :master_terms

  validates :name,
            :presence => true, 
            :length => { :maximum => 250 }
end
# == Schema Information
#
# Table name: master_term_groups
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  name_translated      :string(255)
#  master_style_id      :integer
#  master_federation_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

