class Waypoint < ActiveRecord::Base
  validates_presence_of :dive_id, :unless => :nested
  attr_accessor :nested

   composed_of :depth,  :class_name => "Depth", :mapping =>[ %w(depth_amount amount), %w(depth_unit unit) ]
end
