class DiveSite < ActiveRecord::Base
  scope :random, :order => 'RAND()', :limit => 1
  belongs_to :added_by, :class_name => "User", :foreign_key => "added_by_id"

  serialize :images_hash
  serialize :weblinks_hash

  class << self
    def diver_added(val, user)
      arr = val.split(",").map{|a| a.strip}
      dive_site = DiveSite.find_by_site_and_location(arr[0], arr[1])
      dive_site ||= DiveSite.create(:site => arr[0], :location => arr[1], :added_by => user)
      dive_site
    end
  end

end
