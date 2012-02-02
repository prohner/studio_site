class Term < ActiveRecord::Base
  attr_accessible :term, :term_translated, :description, :phonetic_spelling

  belongs_to :term_group
end
# == Schema Information
#
# Table name: terms
#
#  id                :integer         not null, primary key
#  term              :string(255)
#  term_translated   :string(255)
#  description       :text
#  phonetic_spelling :string(255)
#  term_group_id     :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

