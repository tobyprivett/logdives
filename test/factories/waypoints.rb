# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :waypoint do |f|
  f.dive_id 1
  f.time 1
  f.name "MyString"
  f.depth_amount 1.5
  f.depth_unit :amount
end