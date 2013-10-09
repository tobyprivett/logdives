class Quantity
  attr_reader :amount, :unit
  def initialize(amount, unit=:metric)
    @amount, @unit = amount, (unit || :metric).to_sym
  end

  def imperial?
    @unit == :imperial
  end

  def metric?
    !imperial?
  end

  def imperial!
    @unit = :imperial
  end

  def metric!
    @unit = :metric
  end

  class << self
    def units
      []
    end
  end
end




