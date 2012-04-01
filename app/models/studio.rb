require 'digest'

class Studio < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :password, :password_confirmation
  attr_accessible :name, :email, :address, :address2, :city, :state, :postal_code, :telephone, :fax
  attr_accessible :time_zone
  
  has_many :styles, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :repeating_events, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, 
            :presence   => true,
            :length     => { :maximum => 50 }
                      
  validates :email, 
            :presence   => true,
            :format     => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }


   before_save :encrypt_password

   def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
   end
   
   def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     return nil   if user.nil?
     return user  if user.has_password?(submitted_password)
   end
   
   def self.authenticate_with_salt(id, cookie_salt)
    studio = find_by_id(id)
    (studio && studio.salt == cookie_salt) ? studio : nil
   end


   def uploaded_file=(incoming_file)
     if not incoming_file.nil?
       self.filename = incoming_file.original_filename
       self.content_type = incoming_file.content_type
       self.data = incoming_file.read
     end
   end

   def filename=(new_filename)
       write_attribute("filename", sanitize_filename("#{self.id}_#{new_filename}"))
   end

   private
     def sanitize_filename(filename)
         #get only the filename, not the whole path (from IE)
         just_filename = File.basename(filename)
         #replace all non-alphanumeric, underscore or periods with underscores
         just_filename.gsub(/[^\w\.\-]/, '_')
     end

     def encrypt_password
       self.salt = make_salt unless has_password?(password)
       self.encrypted_password = encrypt(password)
     end

     def encrypt(string)
       secure_hash("#{salt}--#{string}")
     end

     def make_salt
       secure_hash("#{Time.now.utc}--#{password}")
     end

     def secure_hash(string)
       Digest::SHA2.hexdigest(string)
     end
end
# == Schema Information
#
# Table name: studios
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  address            :string(255)
#  address2           :string(255)
#  city               :string(255)
#  state              :string(255)
#  postal_code        :string(255)
#  telephone          :string(255)
#  fax                :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  time_zone          :string(255)
#

