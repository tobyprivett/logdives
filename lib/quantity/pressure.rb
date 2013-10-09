class Pressure < Quantity
  def to_bar
    return @amount if metric?
    @amount / 14.5037738
  end

  def to_psi
    return @amount if imperial?
    @amount * 14.5037738
  end

  def to_s(convert_to=@unit)
    return '' if @amount.blank?
    if convert_to.to_sym == :metric
      "#{to_bar.to_i} bar"
    else
      "#{to_psi.to_i} psi"
    end
  end

  class << self
    def units
      [["psi", "imperial"], ["bar", "metric"]]
    end
  end

end
