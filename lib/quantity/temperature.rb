class Temperature < Quantity
  def to_deg_c
    return @amount if metric?
    (@amount - 32) * 5/9
  end

  def to_deg_f
    return @amount if imperial?
    (@amount * 9/5) + 32
  end

  def to_s(convert_to=@unit)
    return '' if @amount.blank?
    if convert_to.to_sym == :metric
      "#{sprintf('%.1f', to_deg_c)} #{Temperature.deg_c}"
    else
      "#{sprintf('%.1f', to_deg_f)} #{Temperature.deg_f}"
    end
  end


  class << self
    def deg_f; '&#8457;'.html_safe; end

    def deg_c; '&#8451;'.html_safe; end

    def units
      [[Temperature.deg_f, "imperial"], [Temperature.deg_c, "metric"]]
    end
  end
end

