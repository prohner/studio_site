class MasterTerm < ActiveRecord::Base
  belongs_to :master_term_group

  validates :term,
            :presence => true, 
            :length => { :maximum => 250 }

  validates :term_translated,
            :length => { :maximum => 250 }

end
# == Schema Information
#
# Table name: master_terms
#
#  id                   :integer         not null, primary key
#  term                 :string(255)
#  term_translated      :string(255)
#  description          :text
#  master_term_group_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

