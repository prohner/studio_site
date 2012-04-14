require 'spec_helper'

describe TermLibraryController do

  before(:each) do
    @styles = []
    @styles << Factory(:master_style)
    @styles << Factory(:master_style, :name => Factory.next(:name))
    
    @federations = []
    @federations << Factory(:master_federation, :master_style_id => @styles[0].id, :name => Factory.next(:federation_name))
    @federations << Factory(:master_federation, :master_style_id => @styles[0].id, :name => Factory.next(:federation_name))
    @federations << Factory(:master_federation, :master_style_id => @styles[1].id, :name => Factory.next(:federation_name))
    @federations << Factory(:master_federation, :master_style_id => @styles[1].id, :name => Factory.next(:federation_name))

    @term_groups = []
    @term_groups << Factory(:master_term_group, :master_federation_id => @federations[0].id, :name => Factory.next(:term_group_name))
    @term_groups << Factory(:master_term_group, :master_federation_id => @federations[0].id, :name => Factory.next(:term_group_name))
    @term_groups << Factory(:master_term_group, :master_federation_id => @federations[1].id, :name => Factory.next(:term_group_name))
    @term_groups << Factory(:master_term_group, :master_federation_id => @federations[1].id, :name => Factory.next(:term_group_name))
    
    @terms = []
    @term_groups.each do |term_group|
      (0..4).each do |n|
        t1 = Factory(:master_term, :master_term_group_id => term_group.id, :term => Factory.next(:term))
        t2 = Factory(:master_term, :master_term_group_id => term_group.id, :term => Factory.next(:term))
        t3 = Factory(:master_term, :master_term_group_id => term_group.id, :term => Factory.next(:term))
        @terms << t3
        @terms << t2
        @terms << t1
      end
    end
  end

  describe "GET 'show_styles'" do
    before(:each) do
      get 'show_styles'
    end
    
    it "returns http success" do
      response.should be_success
    end
    
    it "returns the styles" do
      @styles.sort! { |a,b| a.name <=> b.name }
      assigns[:styles].should == @styles
    end
    
  end

  describe "GET 'show_federations'" do
    before(:each) do
      @style = @styles[0]
      get 'show_federations', :master_style_id => @style.id
    end
    
    it "returns http success" do
      response.should be_success
    end

    it "returns the styles and federations" do
      assigns[:master_style_id].to_i.should == @styles[0].id
      
      @styles.sort! { |a,b| a.name <=> b.name }
      assigns[:styles].should == @styles

      federations_for_style = @federations.select { |a| a.master_style_id.to_i == @style.id.to_i }
      federations_for_style.sort! { |a,b| a.name <=> b.name }
      assigns[:federations].should == federations_for_style
    end
  end

  describe "GET 'show_term_groups'" do
    before(:each) do
      @federation = @federations[0]
      get 'show_term_groups', :master_federation_id => @federation.id
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right right master style" do
      assigns[:master_style_id].to_i.should == @federation.master_style_id.to_i
    end

    it "should have the right right master_federation_id" do
      assigns[:master_federation_id].to_i.should == @federation.id.to_i
    end
    
    it "should return the styles, sorted the right way" do
      @styles.sort! { |a,b| b.name <=> a.name }
      assigns[:styles].should_not == @styles

      @styles.sort! { |a,b| a.name <=> b.name }
      assigns[:styles].should == @styles
    end
    
    it "should return the federations, sorted the right way"  do
      federations_for_style = @federations.select { |a| a.master_style_id.to_i == @federation.master_style_id.to_i }

      federations_for_style.sort! { |a,b| b.name <=> a.name }
      assigns[:federations].should_not == federations_for_style

      federations_for_style.sort! { |a,b| a.name <=> b.name }
      assigns[:federations].should == federations_for_style
    end
    
    it "should return the term_groups, sorted the right way" do
      term_groups_for_federation = @term_groups.select { |a| a.master_federation_id.to_i == @federation.id.to_i }

      term_groups_for_federation.sort! { |a,b| b.name <=> a.name }
      assigns[:term_groups].should_not == term_groups_for_federation

      term_groups_for_federation.sort! { |a,b| a.name <=> b.name }
      assigns[:term_groups].should == term_groups_for_federation
    end
    
  end

  describe "GET 'show_terms'" do
    before(:each) do
      @term_group = @term_groups[0]
      @federation = @term_group.master_federation

      @term1 = @terms[0]
      @term2 = @terms[1]
      @term3 = @terms[2]

      get 'show_terms', :master_term_group_id => @term_group.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "should have the right right master style" do
      assigns[:master_style_id].to_i.should == @federation.master_style_id.to_i
    end

    it "should have the right right master_federation_id" do
      assigns[:master_federation_id].to_i.should == @federation.id.to_i
    end

    it "should have the right right master_federation_id" do
      assigns[:master_term_group_id].to_i.should == @term_group.id.to_i
    end
    
    it "should return the styles, sorted the right way" do
      @styles.sort! { |a,b| b.name <=> a.name }
      assigns[:styles].should_not == @styles

      @styles.sort! { |a,b| a.name <=> b.name }
      assigns[:styles].should == @styles
    end
    
    it "should return the federations, sorted the right way"  do
      federations_for_style = @federations.select { |a| a.master_style_id.to_i == @federation.master_style_id.to_i }

      federations_for_style.sort! { |a,b| b.name <=> a.name }
      assigns[:federations].should_not == federations_for_style

      federations_for_style.sort! { |a,b| a.name <=> b.name }
      assigns[:federations].should == federations_for_style
    end
    
    it "should return the term_groups, sorted the right way" do
      term_groups_for_federation = @term_groups.select { |a| a.master_federation_id.to_i == @federation.id.to_i }

      term_groups_for_federation.sort! { |a,b| b.name <=> a.name }
      assigns[:term_groups].should_not == term_groups_for_federation

      term_groups_for_federation.sort! { |a,b| a.name <=> b.name }
      assigns[:term_groups].should == term_groups_for_federation
    end
    
    it "should return the terms, sorted the right way" do
      terms_for_term_group = @terms.select { |a| a.master_term_group_id.to_i == @term_group.id.to_i }

      terms_for_term_group.sort! { |a,b| b.term <=> a.term }
      assigns[:terms].should_not == terms_for_term_group

      terms_for_term_group.sort! { |a,b| a.term <=> b.term }
      assigns[:terms].should == terms_for_term_group
    end
  end

end
