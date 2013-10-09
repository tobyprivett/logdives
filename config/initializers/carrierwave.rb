if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end

elsif Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
        :provider               => 'AWS',       # required
        :aws_access_key_id      => 'AKIAIMPVV7JOPYUTWBFA',       # required
        :aws_secret_access_key  => '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'        # required

      }
      config.fog_directory  = 'com.logdives.assets.production'
      config.fog_public     = false                                   # optional, defaults to true
      config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end

end