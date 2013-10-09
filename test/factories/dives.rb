# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :dive do |f|
  f.dive_no 101
  f.template 'rec'
  f.max_depth_amount 1.5
  f.depth_unit 'metric'
  f.total_dive_time 1
  f.dive_date "2011-05-05 20:50:33"
  f.location "My Dive Site"
  f.association :diver, :factory => :user
end


Factory.define :buddy_dive, :class => Dive do |f|
  f.dive_no 212
  f.template 'rec'
  f.max_depth_amount 1.5
  f.depth_unit 'metric'
  f.total_dive_time 1
  f.dive_date "2011-03-05"
  f.location "My Dive Site"
  #f.association :diver, :factory => :buddy_diver
end