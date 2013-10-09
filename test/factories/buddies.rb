# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :buddy do |f|
  f.dive_id 1
end

Factory.define :buddy_awaiting_confirmation, :parent => :buddy do |f|
  f.state 'awaiting_confirmation'
end

Factory.define :buddy_confirmed, :parent => :buddy do |f|
  f.state 'confirmed'
end

Factory.define :buddy_rejected, :parent => :buddy do |f|
  f.state 'rejected'
end