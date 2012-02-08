require 'faker'
namespace :db do
  desc "Load master data for styles"
  task :master_data => :environment do
    #Rake::Task['db:reset'].invoke
    MasterStyle.delete_all
    
    f = File.open(Rails.root.join("lib/tasks/sample_data.txt"))
    records = f.readlines
    records.each do |r|
      vars = r.chomp.split('=')
      unless vars[0].nil?
        if vars[0].starts_with?('ss_style')
          puts "style: #{vars[1]}"
          @style = MasterStyle.create!({ :name => vars[1] })
        elsif vars[0].starts_with?('ss_federation')
          puts "  fed: #{vars[1]}"
          @fed = MasterFederation.create!({ :name => vars[1], :master_style => @style })
        else
          
          puts "    term #{vars[0]}"
        end
      end
    end
  end
  
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

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
  
