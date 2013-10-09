class Depth < Quantity
  def to_metres
    return @amount if metric?
    @amount / 3.2808398950131235
  end

  def to_feet
    return @amount if imperial?
    @amount * 3.2808398950131235
  end

  def to_s(convert_to=@unit)
    return '' if @amount.blank?
    if convert_to.to_sym == :metric
      "#{sprintf('%.1f', to_metres)} m"
    else
      "#{sprintf('%.1f', to_feet)} ft"
    end
  end

  def unit_name
    return "feet" if imperial?
    return "metres" if metric?
  end

  class << self
    def units
      [["feet", "imperial"], ["metres", "metric"]]
    end
  end

end
