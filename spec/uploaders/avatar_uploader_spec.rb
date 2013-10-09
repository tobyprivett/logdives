require 'spec_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(Factory(:user), :avatar)
    @uploader.store!(File.open("#{Rails.root}/test/assets/test_image.png"))
  end

  after do
    AvatarUploader.enable_processing = false
  end

  context 'the mini version' do
    it "should scale down a landscape image to be exactly 30 by 30 pixels" do
      @uploader.mini.should have_dimensions(30, 30)
    end
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 64 by 64 pixels" do
      @uploader.thumb.should have_dimensions(50, 50)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 200 by 200 pixels" do
      @uploader.profile.should be_no_larger_than(180, 180)
    end
  end

end