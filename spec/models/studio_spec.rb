require 'spec_helper'

describe Studio do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    Studio.create!(@attr)
  end

  it "should require a name" do
    no_name_studio = Studio.new(@attr.merge(:name => ""))
    no_name_studio.should_not be_valid
  end

  it "should require an email" do
    no_email_studio = Studio.new(@attr.merge(:email => ""))
    no_email_studio.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_studio = Studio.new(@attr.merge(:name => long_name))
    long_name_studio.should_not be_valid
  end 
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_studio = Studio.new(@attr.merge(:email => address))
      valid_email_studio.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_studio = Studio.new(@attr.merge(:email => address))
      invalid_email_studio.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    Studio.create!(@attr)
    studio_with_duplicate_email = Studio.new(@attr)
    studio_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Studio.create!(@attr.merge(:email => upcased_email))
    studio_with_duplicate_email = Studio.new(@attr)
    studio_with_duplicate_email.should_not be_valid
  end

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

