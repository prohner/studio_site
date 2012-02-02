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