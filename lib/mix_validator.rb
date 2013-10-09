class MixValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:mix, "is invalid") unless (record.he + record.o2 + record.n2).to_i == 100
  end
end