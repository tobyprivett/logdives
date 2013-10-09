class UserUpload < ActiveRecord::Base
  mount_uploader :file, FileUploader
  belongs_to :user
  validates_presence_of :file
  has_many :dives
  has_friendly_id :friendly_string, :use_slug => true

  after_create :import_dives

  def friendly_string
    Time.now
  end

  def import_dives
    dives = DiveImporter.import(file.current_path)
    return unless dives
    dives.map{|dive|
      dive.user_upload_id = self.id
      dive.diver_id =  self.user_id
      dive.save
    }
  end
end
