Factory.define :studio do |studio|
  studio.name                  "Tarzana Karate"
  studio.email                 "tk@example.com"
  studio.password              "foobar123"
  studio.password_confirmation "foobar123"
end

Factory.sequence :name do |n|
  "Person #{n}"
end

Factory.sequence :email do |n|
  "Person-#{n}@example.com"
end

Factory.define :style do |style|
  style.name "style name"
  style.association :studio
end

Factory.define :term_group do |term_group|
  term_group.name "term group name"
  term_group.association :style
end

Factory.define :term do |term|
  term.term             "ahneso phakuro mahk kee"
  term.term_translated  "Inside outside block"
  term.description      "whatever it is as a description"
  term.association :term_group
end

Factory.define :master_style do |style|
  style.name    "master style"
end

Factory.define :master_federation do |fed|
  fed.name            "Hwa Rang"
  fed.master_style_id 1
end

Factory.define :master_term_group do |term_group|
  term_group.name                 "Hwa Rang"
  term_group.name_translated      "Flower Knights"
  term_group.master_style_id      1
  term_group.master_federation_id 1
end

Factory.define :master_term do |term|
  term.term                   "Ha Dan Mahk kee"
  term.term_translated        "Low Block"
  term.master_term_group_id   1
end

Factory.define :event do |ev|
  ev.title      "Event title"
  ev.starts_at  "2/12/2012 09:00"
  ev.ends_at    "2/12/2012 10:00"
end


Factory.define :repeating_event do |ev|
  ev.title      "Event title"
  ev.starts_at  "2/12/2012 09:00"
  ev.ends_at    "2/12/2012 10:00"
end
