class Weight < Quantity
  def to_kg
    return @amount if metric?
    @amount * 0.45359237
  end

  def to_lb
    return @amount if imperial?
    @amount / 0.45359237
  end

  def to_s(convert_to=@unit)
    return '' if @amount.blank?
    if convert_to.to_sym == :metric
      "#{sprintf('%.1f', to_kg)} kg".html_safe
    else
      "#{sprintf('%.1f', to_lb)} lb".html_safe
    end
  end


  class << self
    def units
      [['lb', "imperial"], ['kg', "metric"]]
    end
  end
end
