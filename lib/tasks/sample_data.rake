require 'faker'
namespace :db do
  desc "Load master data for styles"
  task :master_data => :environment do
    #Rake::Task['db:reset'].invoke
    MasterStyle.delete_all
    MasterFederation.delete_all
    MasterTermGroup.delete_all
    MasterTerm.delete_all
    
    f = File.open(Rails.root.join("lib/tasks/sample_data.txt"))
    records = f.readlines
    records.each do |r|
      vars = r.chomp.split('=')
      
      # Capitalize first letter of each word
      vars[1] = vars[1].split(' ').map {|w| w.capitalize }.join(' ') unless vars[1].nil?
      vars[2] = vars[2].split(' ').map {|w| w.capitalize }.join(' ') unless vars[2].nil?
      
      unless vars[0].nil?
        if vars[0].starts_with?('ss_style')
          puts "style: #{vars[1]}"
          @style = MasterStyle.create!({ :name => vars[1] })
        elsif vars[0].starts_with?('ss_federation')
          puts "  fed: #{vars[1]}"
          @federation = MasterFederation.create!({ :name => vars[1], :master_style => @style })
        elsif vars[0].starts_with?('ss_group')
          puts "  tg: #{vars[1]} #{vars[2]}"
          @term_group = MasterTermGroup.create!({ :name => vars[1], :name_translated => vars[2], :master_federation => @federation })
        else
          vars[0] = vars[0].split(' ').map {|w| w.capitalize }.join(' ') unless vars[0].nil?
          #puts "0==#{vars[0]}, 1==#{vars[1]}, 2==#{vars[2]}"
          #if vars[1].nil?
          #  vars[2] = vars[1] 
          #  vars[1] = vars[0] 
          #  exit
          #end
          @term = MasterTerm.create!({ :term => vars[0], :term_translated => vars[1], :master_term_group => @term_group })
        end
      end
    end
  end

  desc "Fill calendar with sample data"
  task :cal => :environment do
    Event.delete_all
    Event.create!(:title => "Private Lesson",             :starts_at => Time.local(2012, 2, 15, 8),       :ends_at => Time.local(2012, 2, 15, 9),  :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Adults All Levels",          :starts_at => Time.local(2012, 2, 15, 9, 30),   :ends_at => Time.local(2012, 2, 15, 10, 30), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Kids White, Yellow & Green", :starts_at => Time.local(2012, 2, 15, 10),      :ends_at => Time.local(2012, 2, 15, 11), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Kids Red & Black",           :starts_at => Time.local(2012, 2, 15, 17),      :ends_at => Time.local(2012, 2, 15, 18), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Adults All Levels",          :starts_at => Time.local(2012, 2, 15, 19),      :ends_at => Time.local(2012, 2, 15, 20), :all_day => false, :description => "Class description goes here and the text might get kind of long")

    Event.create!(:title => "Free Sparring",              :starts_at => Time.local(2012, 2, 16, 8),       :ends_at => Time.local(2012, 2, 16, 9),  :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Adult All Levels",           :starts_at => Time.local(2012, 2, 16, 9),       :ends_at => Time.local(2012, 2, 16, 10), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Kids White, Yellow & Green", :starts_at => Time.local(2012, 2, 16, 10),      :ends_at => Time.local(2012, 2, 16, 11), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Kids Red & Black",           :starts_at => Time.local(2012, 2, 16, 11),      :ends_at => Time.local(2012, 2, 16, 12), :all_day => false, :description => "Class description goes here and the text might get kind of long")
    Event.create!(:title => "Adult Senior Class",         :starts_at => Time.local(2012, 2, 16, 14),      :ends_at => Time.local(2012, 2, 16, 15), :all_day => false, :description => "Class description goes here and the text might get kind of long")

  end
  
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:master_data'].invoke
    Rake::Task['db:cal'].invoke

    admin_studio = Studio.create!( :name => "Admin Stud", :password => "123456", :email => "abc@def.com")
    admin_studio.toggle!(:admin)
    tsd     = admin_studio.styles.create!(:name => "Tang soo do")
    karate  = admin_studio.styles.create!(:name => "Shotokan")
    jj      = admin_studio.styles.create!(:name => "Jiu Jitsu")
    
    tg = tsd.term_groups.create!(:name => "Mahk kee", :name_translated => "Blocks")
    tg.terms.create!(:term => "Ha dan mahk kee", :term_translated => "Low block")
    tg.terms.create!(:term => "Sang dan mahk kee", :term_translated => "High block")
    tg.terms.create!(:term => "Ahneso phakuro mahk kee", :term_translated => "Inside-to-outside block", :description => "Hand comes across the body in a sweeping motion")
    tg.terms.create!(:term => "Phakeso ahnuro mahk kee", :term_translated => "Outside-to-inside block")
    
    tg = tsd.term_groups.create!(:name => "Bahl Gi Sool", :name_translated => "Foot Techniques")
    tg.terms.create!(:term => "Ahp podo oll ri ki cha gi", :term_translated => "Front stretch kick")
    tg.terms.create!(:term => "Ahneso phakuro cha gi", :term_translated => "Inside-to-outside kick")
    tg.terms.create!(:term => "Phakeso ahnuro cha gi", :term_translated => "Outside-to-inside kick")

    tg = jj.term_groups.create!(:name => "Terminology")
    tg.terms.create!(:term => "Atemi", :term_translated => "striking")
    tg.terms.create!(:term => "Bushido", :term_translated => "way of the warrior")
    tg.terms.create!(:term => "Eri", :term_translated => "jacket collar")
    tg.terms.create!(:term => "Gatame", :term_translated => "arm bar (lock)")
    tg.terms.create!(:term => "Hadaka Jime", :term_translated => "naked strangle or choke")

    tg = karate.term_groups.create!(:name => "General Terms")
    tg.terms.create!(:term => "karate do", :term_translated => "empty handed way")
    tg.terms.create!(:term => "shihan", :term_translated => "master")
    tg.terms.create!(:term => "sensei", :term_translated => "teacher")
    tg.terms.create!(:term => "sempai", :term_translated => "senior student")
    tg.terms.create!(:term => "kohai", :term_translated => "junior student")
    
    tg = karate.term_groups.create!(:name => "STANCES")
    tg.terms.create!(:term => "zenkutsu dachi", :term_translated => "front stance")
    tg.terms.create!(:term => "kokutsu dachi", :term_translated => "back stance")
    tg.terms.create!(:term => "kiba dachi", :term_translated => "horse stance")
    
    make_studios
    
    3.times do
      Studio.all(:limit => 10).each do |studio|
        if admin_studio != studio 
          studio.styles.create!(:name => Faker::Lorem.words(1).first)
        end
      end
    end
  end
end

def make_studios

  55.times do |n|
    studio  = Studio.create!( :name => Faker::Company.name, :password => "password #{n}", :email => Faker::Internet.email)
    studio.address = Faker::Address.street_address
    studio.city = Faker::Address.city
    studio.state = Faker::Address.us_state_abbr
    studio.postal_code = Faker::Address.zip_code
    studio.telephone = Faker::PhoneNumber.phone_number
    studio.fax = Faker::PhoneNumber.phone_number
    studio.email = Faker::Internet.email
    studio.save!
    
    #country = Country.create!(:name => "Country: " + Faker::Name.name)

    #rand_with_range(1..8).times do |n2|
    #  style   = Style.create!(:name => "Style: " + Faker::Name.name,
    #                          :country => country,
    #                          :studio => studio)
                              
    #  terms = Faker::Lorem.words(rand(20))
    #  terms.each do |term|
    #    translated  = Faker::Lorem.words().first
    #    definition  = Faker::Lorem.paragraph
    #    Term.create!( :name             => term,
    #                  :translated_term  => translated,
    #                  :definition       => definition,
    #                  :style            => style
    #                  )
    #    #puts "#{studio.name}: #{term}"
    #            
    #  end
    #end
  end
end

def rand_with_range(values = nil)
  if values.respond_to? :sort_by
    values.sort_by { rand }.first
  else
    rand(values)
  end
end
  
