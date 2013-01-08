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
    curr_mon = Time.now.month
    
    RepeatingEvent.delete_all
    Event.delete_all
    
    if false
      RepeatingEvent.create!(:starts_at => make_time(2012, 2, 1, 9, 0),  :ends_at => make_time(2012, 3, 1, 10),  :repetition_type => "weekly", :on_monday => true, :title => "Mon - Monthlong",    :description => "A repeating class", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 2, 15, 9, 0), :ends_at => make_time(2012, 3, 15, 10), :repetition_type => "weekly", :on_wednesday => true, :title => "Wed - Monthlong", :description => "A repeating class", :all_day => false, :studio_id => 1)

      RepeatingEvent.create!(:starts_at => make_time(2012, 2, 1, 13),  :ends_at => make_time(2013, 3, 1, 14),  :repetition_type => "weekly", :on_monday => true, :title => "Mon - Yearlong",    :description => "A repeating class", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 2, 1, 13),  :ends_at => make_time(2013, 3, 15, 14), :repetition_type => "weekly", :on_wednesday => true, :title => "Wed - Yearlong", :description => "A repeating class", :all_day => false, :studio_id => 1)

      RepeatingEvent.create!(:starts_at => make_time(2012, 1, 1, 9), :ends_at => make_time(2012, 1, 15, 10), :repetition_type => "weekly", :on_wednesday => true, :title => "Historical repeater", :description => "A repeating class", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 4, 1, 9), :ends_at => make_time(2012, 4, 15, 10), :repetition_type => "weekly", :on_wednesday => true, :title => "Future repeater", :description => "A repeating class", :all_day => false, :studio_id => 1)

      Event.create!(:title => "Private Lesson",             :starts_at => make_time(2012, curr_mon, 15, 8),       :ends_at => make_time(2012, curr_mon, 15, 9),  :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Adults All Levels",          :starts_at => make_time(2012, curr_mon, 15, 9, 30),   :ends_at => make_time(2012, curr_mon, 15, 10, 30), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Kids White, Yellow & Green", :starts_at => make_time(2012, curr_mon, 15, 10),      :ends_at => make_time(2012, curr_mon, 15, 11), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Kids Red & Black",           :starts_at => make_time(2012, curr_mon, 15, 17),      :ends_at => make_time(2012, curr_mon, 15, 18), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Adults All Levels",          :starts_at => make_time(2012, curr_mon, 15, 19),      :ends_at => make_time(2012, curr_mon, 15, 20), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)

      Event.create!(:title => "Free Sparring",              :starts_at => make_time(2012, curr_mon, 16, 8),       :ends_at => make_time(2012, curr_mon, 16, 9),  :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Adult All Levels",           :starts_at => make_time(2012, curr_mon, 16, 9),       :ends_at => make_time(2012, curr_mon, 16, 10), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Kids White, Yellow & Green", :starts_at => make_time(2012, curr_mon, 16, 10),      :ends_at => make_time(2012, curr_mon, 16, 11), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Kids Red & Black",           :starts_at => make_time(2012, curr_mon, 16, 11),      :ends_at => make_time(2012, curr_mon, 16, 12), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
      Event.create!(:title => "Adult Senior Class",         :starts_at => make_time(2012, curr_mon, 16, 14),      :ends_at => make_time(2012, curr_mon, 16, 15), :all_day => false, :description => "Class description goes here and the text might get kind of long", :studio_id => 1)
    else
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 9, 30),  :ends_at => make_time(2013, 3, 1, 10, 30), :repetition_type => "weekly", :on_monday => true, :on_wednesday => true, :on_friday => true, :title => "Healing Class", :color => "darkred", :description => "Stretch and yoga", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 11, 00), :ends_at => make_time(2013, 3, 1, 11, 45), :repetition_type => "weekly", :on_monday => true, :on_wednesday => true, :on_friday => true, :title => "Mom & Me", :color => "royalblue", :description => "", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 16, 00), :ends_at => make_time(2013, 3, 1, 16, 30), :repetition_type => "weekly", :on_monday => true, :on_tuesday => true, :on_friday => true, :title => "LIL DRAGONS", :color => "green", :description => "3-6 year olds", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 16, 30), :ends_at => make_time(2013, 3, 1, 17, 10), :repetition_type => "weekly", :on_monday => true, :on_tuesday => true, :on_thursday => true, :title => "Children 1", :color => "green", :description => "White & Yellow Belts", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 17, 10), :ends_at => make_time(2013, 3, 1, 18, 00), :repetition_type => "weekly", :on_monday => true, :on_tuesday => true, :on_thursday => true, :title => "Children 3", :color => "darkolivegreen", :description => "Green, Red & Black", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 17, 10), :ends_at => make_time(2013, 3, 1, 18, 00), :repetition_type => "weekly", :on_wednesday => true, :title => "Children 1 & 2", :description => "White to Green Belts", :color => "green", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 18, 10), :ends_at => make_time(2013, 3, 1, 19, 00), :repetition_type => "weekly", :on_monday => true, :on_tuesday => true, :on_thursday => true, :title => "Children 1 & 2", :color => "green", :description => "White to Green Belts", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 18, 10), :ends_at => make_time(2013, 3, 1, 19, 00), :repetition_type => "weekly", :on_wednesday => true, :title => "Children 3", :color => "darkolivegreen", :description => "Green, Red & Black", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 18, 10), :ends_at => make_time(2013, 3, 1, 19, 00), :repetition_type => "weekly", :on_friday => true, :title => "Gymnastics/Weapons", :color => "darkolivegreen", :description => "All belts", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 19, 00), :ends_at => make_time(2013, 3, 1, 20, 00), :repetition_type => "weekly", :on_monday => true, :on_tuesday => true, :on_wednesday => true, :on_thursday => true, :title => "Adults All Belts", :color => "royalblue", :description => "", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1,  9, 00), :ends_at => make_time(2013, 3, 1, 10, 00), :repetition_type => "weekly", :on_saturday => true, :title => "All Adults", :color => "royalblue", :description => "", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 10, 00), :ends_at => make_time(2013, 3, 1, 10, 45), :repetition_type => "weekly", :on_saturday => true, :title => "Children", :color => "royalblue", :description => "Green and up", :all_day => false, :studio_id => 1)
      RepeatingEvent.create!(:starts_at => make_time(2012, 3, 1, 11, 00), :ends_at => make_time(2013, 3, 1, 11, 45), :repetition_type => "weekly", :on_saturday => true, :title => "Children", :color => "royalblue", :description => "", :all_day => false, :studio_id => 1)

      Event.create!(:title => "Promotions & Banquet", :starts_at => make_time(2012, curr_mon, 1, 17),       :ends_at => make_time(2012, curr_mon, 1, 20, 0),  :all_day => false, :description => "Delicious pot luck buffet", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "World Dang Soo Do Union Championship", :starts_at => make_time(2012, 4, 13, 0),       :ends_at => make_time(2012, 4, 14, 0),  :all_day => true, :description => "Lancaster, Ohio", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "31st Dan Testing at Master Harshall", :starts_at => make_time(2012, 4, 20, 0),       :ends_at => make_time(2012, 4, 22, 0),  :all_day => true, :description => "Latrobe, Pennsylvania", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "Grand Master Samane Seminar", :starts_at => make_time(2012, 5, 4, 0),       :ends_at => make_time(2012, 5, 6, 0),  :all_day => true, :description => "Philadelphia, Pennslyvania", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "32nd Dan Testing West Coast at HRWTSDF  HQ", :starts_at => make_time(2012, 5, 17, 17),       :ends_at => make_time(2012, 5, 17, 20),  :all_day => false, :description => "Tarzana, California", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "HRWTSDF Seminar", :starts_at => make_time(2012, 5, 18, 15),       :ends_at => make_time(2012, 5, 18, 17),  :all_day => false, :description => "Tarzana, California", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "Battle Of L.A.", :starts_at => make_time(2012, 5, 19, 15),       :ends_at => make_time(2012, 5, 19, 17),  :all_day => true, :description => "Tarzana, California", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "South Korea and China Tour", :starts_at => make_time(2012, 8, 2, 15),       :ends_at => make_time(2012, 8, 11, 17),  :all_day => true, :description => "", :studio_id => 1, :color => "darkgoldenrod")

      Event.create!(:title => "Grand Master Samane Seminar", :starts_at => make_time(2012, 10, 12, 0),       :ends_at => make_time(2012, 10, 15, 0),  :all_day => true, :description => "Philadelphia, Pennslyvania", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "United Kingdom Seminars & Dan Testing", :starts_at => make_time(2012, 10, 16, 0),       :ends_at => make_time(2012, 10, 20, 0),  :all_day => true, :description => "", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "33rd Dan Testing at Master Delenela", :starts_at => make_time(2012, 11, 16, 0),       :ends_at => make_time(2012, 11, 18, 0),  :all_day => true, :description => "Austin, Texas", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "34th Dan Testing West Coast at HRWTSDF  HQ", :starts_at => make_time(2012, 12, 1, 17),       :ends_at => make_time(2012, 12, 1, 20),  :all_day => false, :description => "Tarzana, California", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "Gup Testing", :starts_at => make_time(2012, 12, 13, 19),       :ends_at => make_time(2012, 12, 13, 20),  :all_day => false, :description => "Tarzana, California", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "Promotions & Banquet", :starts_at => make_time(2012, 12, 20, 17),       :ends_at => make_time(2012, 12, 20, 20, 0),  :all_day => false, :description => "Delicious pot luck buffet", :studio_id => 1, :color => "darkgoldenrod")

      Event.create!(:title => "DM Sales Flyer (40% RPI & 60% off TTL Order)", :starts_at => make_time(2013, 5, 20, 0), :ends_at => make_time(2013, 6, 9, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "blue")
      Event.create!(:title => "DM Sales Flyer (40% RPI & 50% + $200 off TTL)", :starts_at => make_time(2013, 6, 10, 0), :ends_at => make_time(2013, 6, 23, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "blue")

      Event.create!(:title => "NPI BS (40% RPI & 60% off TTL Order)", :starts_at => make_time(2013, 5, 27, 0), :ends_at => make_time(2013, 6, 2, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "darkgoldenrod")
      Event.create!(:title => "NPI Baby Event (50% RPI & 60% off TTL Order)", :starts_at => make_time(2013, 6, 3, 0), :ends_at => make_time(2013, 6, 9, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "darkgoldenrod")

      Event.create!(:title => "SMS (50% RPI)", :starts_at => make_time(2013, 6, 10, 0), :ends_at => make_time(2013, 6, 16, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "green")

      Event.create!(:title => "Email Firefly Frenzy (50% RPI)", :starts_at => make_time(2013, 6, 10, 0), :ends_at => make_time(2013, 6, 23, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "darkorchid")
      Event.create!(:title => "Email Celebrate Savings (40% off ES Scrapbook)", :starts_at => make_time(2013, 6, 24, 0), :ends_at => make_time(2013, 6, 30, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "darkorchid")

      Event.create!(:title => "Postcard July 4th & Military", :starts_at => make_time(2013, 6, 24, 0), :ends_at => make_time(2013, 7, 3, 0),  :all_day => true, :description => "40% RPI & 60% off TTL Order", :studio_id => 1, :color => "fuchsia")
    end


  end
  
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:master_data'].invoke

    admin_studio = Studio.create!(:name => "Admin Stud", :password => "123456", :email => "abc@def.com")
    admin_studio.address = Faker::Address.street_address
    admin_studio.city = Faker::Address.city
    admin_studio.state = Faker::Address.us_state_abbr
    admin_studio.postal_code = Faker::Address.zip_code
    admin_studio.telephone = Faker::PhoneNumber.phone_number
    admin_studio.fax = Faker::PhoneNumber.phone_number
    admin_studio.save!
    

    Rake::Task['db:cal'].invoke

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

def make_time(y, m, d, h, mi=0)
  Time.utc(y, m, d, h, mi)
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
  
