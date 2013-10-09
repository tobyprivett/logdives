class FileUploader < CarrierWave::Uploader::Base
  storage :file


  def store_dir
    if Rails.env.test?
      "#{Rails.root}/tmp/test_uploads"
    elsif Rails.env.development?
        "#{Rails.root}/tmp/dev_uploads"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

end
