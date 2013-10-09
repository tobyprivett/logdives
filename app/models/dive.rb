class Dive < ActiveRecord::Base
  include Charting

  validates_presence_of :dive_date
  validates_presence_of :location

  belongs_to :diver, :class_name => "User", :foreign_key => "diver_id"
  serialize :samples
  has_friendly_id :location, :use_slug => true
  def normalize_friendly_id(text)
     "#{self.dive_no}-#{self.location.parameterize}"
  end

  has_many :photos,  :dependent => :destroy
  has_many :tanks,   :dependent => :destroy
  has_many :waypoints, :dependent => :destroy
  has_many :buddies, :dependent => :destroy
  has_many :confirmed_buddies, :class_name => "Buddy", :conditions => {:state => 'Confirmed'}

  accepts_nested_attributes_for :tanks, :allow_destroy => true, :reject_if => proc{|b| !b[:nested].blank?}
  accepts_nested_attributes_for :waypoints, :allow_destroy => true, :reject_if => proc{|b|  b[:time].blank? }
  accepts_nested_attributes_for :buddies, :allow_destroy => true, :reject_if => proc{|b| (b[:buddy_diver_name].blank? && b[:id].blank?)}

  has_and_belongs_to_many :conditions, :join_table => "dives_conditions", :foreign_key => "dive_id", :order => 'conditions.name'
  has_and_belongs_to_many :exposure_suits, :join_table => "dives_exposure_suits", :foreign_key => "dive_id", :order => 'exposure_suits.name'

  before_destroy :cleanup_for_destroy
  before_save :mark_chidren_for_removal, :save_dive_site

  composed_of :max_depth,  :class_name => "Depth", :mapping =>[ %w(max_depth_amount amount), %w(depth_unit unit) ]
  composed_of :average_depth,  :class_name => "Depth", :mapping =>[ %w(average_depth_amount amount), %w(depth_unit unit) ]
  composed_of :weight, :class_name => "Weight", :mapping =>[ %w(weight_amount amount), %w(weight_unit unit) ]
  composed_of :air_temp, :class_name => "Temperature", :mapping =>[ %w(air_temperature amount), %w(temperature_unit unit) ]
  composed_of :water_temp_surface, :class_name => "Temperature", :mapping =>[ %w(water_temperature_on_surface amount), %w(temperature_unit unit) ]
  composed_of :water_temp_depth, :class_name => "Temperature", :mapping =>[ %w(water_temperature_at_depth amount), %w(temperature_unit unit) ]

  class << self

    def init_with_units(unit)
      dive = Dive.new :depth_unit => unit, :temperature_unit => unit, :weight_unit => unit
      dive.tanks.build :pressure_unit => unit
      dive.waypoints.build :depth_unit => unit
      dive
    end

    def init_with_diver(diver_obj)
      dive = Dive.new
      last_dive = diver_obj.dives.last_updated.limit(1).first

      if last_dive.present?
        last_dive.tanks.each do |tank|
          dive.tanks << Tank.new(:nested => 'attr-hack',
                :volume => tank.volume, :volume_unit => tank.volume_unit,
                :mix => tank.mix, :pressure_unit => tank.pressure_unit)
        end
        dive.template = last_dive.template
        dive.depth_unit = last_dive.depth_unit
        dive.temperature_unit = last_dive.temperature_unit
        dive.weight_unit = last_dive.weight_unit
        dive.tanks_visible = last_dive.tanks_visible
        dive.buddy_visible = last_dive.buddy_visible
        dive.profile_visible = last_dive.profile_visible
        dive.photos_visible = last_dive.photos_visible
        dive.equipment_visible = last_dive.equipment_visible
        dive.conditions_visible = last_dive.conditions_visible
        dive.notes_visible = last_dive.notes_visible
        dive.weight = last_dive.weight
        last_dive.exposure_suits.each do |exposure_suit|
          dive.exposure_suits << exposure_suit
        end
      end

      dive.diver = diver_obj
      dive.dive_no = ((diver_obj.dives.maximum(:dive_no) || 0) + 1)
      return dive
    end

    def reciprocate_for_buddy!(buddy_obj)
      return buddy_obj.reciprocal_dive if buddy_obj.reciprocal_dive

      dive_obj = buddy_obj.dive
      dive = Dive.init_with_diver(buddy_obj.buddy_diver)

      dive.location = dive_obj.location
      dive.dive_date = dive_obj.dive_date
      dive.max_depth = dive_obj.max_depth
      dive.average_depth  = dive_obj.average_depth
      dive.total_dive_time = dive_obj.total_dive_time

      dive.air_temp = dive_obj.air_temp
      dive.water_temp_surface = dive.water_temp_surface
      dive.water_temp_depth = dive_obj.water_temp_depth
      dive.temperature_unit = dive_obj.temperature_unit

      dive_obj.conditions.each{ |c|  dive.dive_conditions << c } if dive_obj.conditions
      dive_obj.waypoints.each{ |w|  dive.waypoints << w } if dive_obj.waypoints

      if dive_obj.diver
        dive.buddies << Buddy.new(:buddy_diver_id => dive_obj.diver_id, :state => :confirmed,
                    :nested => 'attr-hack', :reciprocal_dive_id => buddy_obj.dive_id)
      end
      dive.save!
      buddy_obj.update_attribute :reciprocal_dive_id, dive.buddies.first.dive_id
      dive.tanks.map{ |tank| tank.update_attribute :dive_id, dive.id }
      return dive
    end

    def last_updated
      order('updated_at desc').eagerly
    end

    def eagerly
      includes(:diver, {:buddies => [:buddy_diver]}, :waypoints, :tanks, :conditions, :exposure_suits, :photos, :slug)
    end

    def lightly
       includes(:diver, {:confirmed_buddies => [:buddy_diver]}, :photos, :slug)
    end

    def check_saveable
      return false unless self.saveable
    end
  end

  def max_depth_and_time(unit)
    ret = []
    ret << max_depth.to_s(unit) if max_depth_amount.to_i > 0
    ret << "#{total_dive_time} mins" if total_dive_time.to_i > 0
    ret.join(" / ")
  end

  def diver_name
    return '' unless diver
    diver.name
  end

  def editable_by?(user_obj)
    self.diver.present? && self.diver == user_obj
  end

  protected
  def set_dive_number
    return unless self.diver
    self.dive_no = (diver.dives.maximum(:dive_no) || 0) + 1
  end

  def mark_chidren_for_removal
    self.tanks.each do |tank|
      tank.mark_for_destruction if tank.nested == 'deleted'
    end

    self.waypoints.each do |waypoint|
      waypoint.mark_for_destruction if waypoint.nested == 'deleted'
    end

    self.buddies.each do |buddy|
      buddy.mark_for_destruction if buddy.nested == 'deleted' || !buddy.buddy_diver
    end
  end

  def save_dive_site
    DiveSite.diver_added(self.location, self.diver) if self.location_changed?
  end

  def cleanup_for_destroy
    Buddy.where(:reciprocal_dive_id => self.id).each do |buddy|
      buddy.update_attribute :reciprocal_dive_id, nil
    end
  end

end
