module Units
  def to_feet(val)
    metric? ? val : val.metres.to_feet
  end

  def alt_units
    metric? ? :imperial : :metric
  end

  def depth_unit
    metric? ? 'metres' : 'feet'
  end

  def depth_unit_abbrev
    metric? ? 'm' : 'ft'
  end

  def alt_depth_unit
    metric? ? 'feet' : 'metres'
  end

  def imperial?
    return false unless units
    units.to_sym == :imperial
  end

  def metric?
    !imperial?
  end

  def imperial!
    self.units = :imperial
  end

  def metric!
    self.units = :metric
  end
end