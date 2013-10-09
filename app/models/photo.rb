class Photo < ActiveRecord::Base
  belongs_to :dive, :counter_cache => true
  mount_uploader :image, PhotoUploader
end
