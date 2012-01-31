class Studio < ActiveRecord::Base
  attr_accessible :name, :email, :address, :address2, :city, :state, :postal_code, :telephone, :fax

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, 
            :presence   => true,
            :length     => { :maximum => 50 }
                      
  validates :email, 
            :presence   => true,
            :format     => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
end
# == Schema Information
#
# Table name: studios
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  email       :string(255)
#  address     :string(255)
#  address2    :string(255)
#  city        :string(255)
#  state       :string(255)
#  postal_code :string(255)
#  telephone   :string(255)
#  fax         :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

