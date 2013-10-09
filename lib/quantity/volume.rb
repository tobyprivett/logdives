class Volume < Quantity

  def to_s
    "#{sprintf('%.1f', amount)} #{unit_name}" if amount.to_f > 0.0
  end

  def unit_name
    return "cu. ft." if imperial?
    return "litres" if metric?
  end

  class << self
    def units
      [["cu. ft.", "imperial"], ["litres", "metric"]]
    end
  end

end
