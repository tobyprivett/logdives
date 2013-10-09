if User.count == 0
  user = User.new :email => 'toby@snaplab.co.uk', :password => 'password', :password_confirmation => 'password'
  user.bypass_humanizer = true
  user.save!
end

if Condition.count == 0
   ["Fresh", "Salt", "Shore", "Waves", "Current", "Surf", "Surge"].map {|c| Condition.create :name => c}
end

if ExposureSuit.count == 0
   ["Full", "Shortie", "Hood", "Gloves", "Boots", "Drysuit", "Torch"].map {|e| ExposureSuit.create :name => e}
end




