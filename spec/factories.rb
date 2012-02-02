Factory.define :studio do |studio|
  studio.name                  "Tarzana Karate"
  studio.email                 "tk@example.com"
  studio.password              "foobar123"
  studio.password_confirmation "foobar123"
end

#Factory.define :studio2 do |studio|
#  studio.name                  "Family Karate"
#  studio.email                 "tk@blah.com"
#  studio.password              "whatever"
#  studio.password_confirmation "whatever"
#end

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