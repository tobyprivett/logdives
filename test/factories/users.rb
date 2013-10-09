Factory.define :user do |u|
  u.email 'example@example.com'
  u.password 'password'
  u.password_confirmation 'password'
  u.name 'Toby'
  u.bypass_humanizer true
  u.confirmed_at 1.hour.ago
end

Factory.define :anon_user, :class => User do |u|
  u.email 'name@example.com'
  u.password 'password'
  u.password_confirmation 'password'
  u.name nil
  u.bypass_humanizer true
  u.confirmed_at 1.hour.ago
end

Factory.define :confirmed_user, :parent => :user do |u|
  u.confirmed_at 1.day.ago
end

Factory.define :another_user, :parent => :user do |u|
  u.email 'another_user@example.com'
  u.name 'Joe Diver'
  u.confirmed_at 1.year.ago
end

Factory.define :yet_another_user, :parent => :user do |u|
  u.email 'Yet_another_user@example.com'
  u.name 'Another Joe Diver'
  u.confirmed_at 1.year.ago
end

Factory.define :buddy_diver, :parent => :user do |u|
  u.email "buddy-diver@example.com"
  u.confirmed_at 1.year.ago
end
