class Tank < ActiveRecord::Base
  validates_presence_of :dive_id, :unless => :nested
  attr_accessor :nested
  belongs_to :dive

  composed_of :starting,  :class_name => "Pressure", :mapping =>[ %w(start_pressure amount), %w(pressure_unit unit) ]
  composed_of :ending,  :class_name => "Pressure", :mapping =>[ %w(end_pressure amount), %w(pressure_unit unit) ]
  composed_of :mix, :class_name => 'Mix', :mapping => [ %w(mix_type mix_type), %w(o2 o2), %w(he he), %w(n2 n2) ]
  composed_of :size,  :class_name => "Volume", :mapping =>[ %w(volume amount), %w(volume_unit unit) ]
  before_validation :set_mix_values!
  validates_with MixValidator

  protected

  def set_mix_values!
    case self.mix_type.downcase.to_sym
    when :nitrox
      self.he, self.n2  = 0, (100 - self.o2)
    when :trimix
      self.n2 = (100 - self.o2 - self.he)
    when :heliox
      self.n2 = 0
    else
      self.o2, self.he, self.n2 = 21, 0, 79
    end
  end
end
