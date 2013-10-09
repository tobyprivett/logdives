namespace :lgd do

  task :dev => :environment do
    path = ''
    p DiveImporter.import path
  end

  task :faker => :environment do

    1.upto(100) do

      pwd = ActiveSupport::SecureRandom.base64(6)
      email = "#{Faker::Internet.user_name}@example.com"
      user = User.create(:email => email, :password => pwd, :password_confirmation => pwd)

      Random.new.rand(1..150).times do

        dive = user.dives.create!(:location => DiveSite.random.first.site, :dive_date => rand(365).days.ago,
        :total_dive_time => Random.new.rand(20..110), :max_depth_amount => Random.new.rand(6..42),
        :depth_unit => :metric)


        if Random.new.rand(1..3) < 3
          buddy_role = (Random.new.rand(1..2) == 1) ? 'Instructor' : 'Buddy'
          dive.buddies << Buddy.new(:email => User.random.first.email, :role => buddy_role)
          dive.save!
          if Random.new.rand(1..3) < 3
            dive.buddies.first.send_confirmation_request
            if Random.new.rand(1..3) < 2
              dive.buddies.first.confirm!
            end
            dive.save!
          end
        end
      end

    end

  end
end
