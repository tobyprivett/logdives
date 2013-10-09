require 'spec_helper'
require 'carrierwave/test/matchers'

describe FileUploader do
  include CarrierWave::Test::Matchers

  before(:each) do
    FileUploader.enable_processing = true
    @uploader = FileUploader.new(:file)
  end

  after do
    FileUploader.enable_processing = false
  end

  it "should save a suunto file" do
    @uploader.store!(File.open("#{Rails.root}/test/assets/suunto_sample.SDE")).should be_true
  end

   it "should save a file even we can't process it" do
     @uploader.store!(File.open("#{Rails.root}/test/assets/invalid_file")).should be_true
   end

end