class Term < ActiveRecord::Base
  attr_accessor :image
  attr_accessible :term, :term_translated, :description, :phonetic_spelling, :term_group_id

  belongs_to :term_group

  validates :term,              :presence => true, :length => { :maximum => 250 }
  validates :term_translated,   :length => { :maximum => 250 }
  validates :phonetic_spelling, :length => { :maximum => 250 }
  validates :term_group_id,     :presence => true

  default_scope :order => 'terms.term'

  def uploaded_file=(incoming_file)
    if not incoming_file.nil?
      self.filename = incoming_file.original_filename
      self.content_type = incoming_file.content_type
      self.data = incoming_file.read
    end
  end

  def filename=(new_filename)
      write_attribute("filename", sanitize_filename("#{self.id}#{new_filename}"))
  end

  private
  def sanitize_filename(filename)
      #get only the filename, not the whole path (from IE)
      just_filename = File.basename(filename)
      #replace all non-alphanumeric, underscore or periods with underscores
      just_filename.gsub(/[^\w\.\-]/, '_')
  end
    
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
#  image_name        :string(255)
#

