require 'spec_helper'

describe Studio do
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
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

  describe "password validations" do

    it "should require a password" do
      Studio.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      Studio.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
  
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      Studio.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      Studio.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @studio = Studio.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @studio.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @studio.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do

      it "should be true if the passwords match" do
        @studio.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @studio.has_password?("invalid").should be_false
      end 
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password = Studio.authenticate(@attr[:email], "wrongpass")
        wrong_password.should be_nil
      end
      
      it "should return nil for an email address with no studio" do
        nonexistent_studio = Studio.authenticate("bad@abc.com", @attr[:password])
        nonexistent_studio.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_studio = Studio.authenticate(@attr[:email], @attr[:password])
        matching_studio.should == @studio
      end
    end
  end
  
  describe "style associations" do
    before(:each) do
      @studio = Studio.create(@attr)
      @style_a = Factory(:style, :studio => @studio, :name => "A style")
      @style_b = Factory(:style, :studio => @studio, :name => "B style")
    end
    
    it "should have a styles attribute" do
      @studio.should respond_to(:styles)
    end
    
    it "should have the right styles in the right order" do
      @studio.styles.should == [@style_a, @style_b]
    end
    
    it "should destroy associated styles" do
      @studio.destroy
      [@style_a, @style_b].each do |style|
        Style.find_by_id(style.id).should be_nil
      end
    end
  end
  
  
  describe "admin attribute" do
    before(:each) do
      @studio = Studio.create!(@attr)
    end
    
    it "should respond to admin" do
      @studio.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @studio.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @studio.toggle!(:admin)
      @studio.should be_admin
    end 
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
#

