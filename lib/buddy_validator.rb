class BuddyValidator < ActiveModel::Validator
  def validate(record)
    if record.dive && record.diver &&  (record.diver == record.buddy_diver)
      record.errors.add(:buddy_diver_name, "can not be you")
    end
  end
end