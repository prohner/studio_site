class TermGroup < ActiveRecord::Base
  attr_accessible :name

  belongs_to :style
  has_many :terms, :dependent => :destroy

  validates :name,      :presence => true, :length => { :maximum => 250 }
  validates :style_id,  :presence => true

  default_scope :order => 'term_groups.name'
end
# == Schema Information
#
# Table name: term_groups
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  style_id          :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  phonetic_spelling :string(255)
#  name_translated   :string(255)
#

