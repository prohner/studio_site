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