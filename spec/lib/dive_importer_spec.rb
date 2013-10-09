require 'spec_helper'

describe DiveImporter do
  before do
    @invalid_file =  "#{Rails.root}/test/assets/invalid_file"
    @suunto_sdm_file = "#{Rails.root}/test/assets/suunto_sample.SDE"
    @suunto_xml_file = "#{Rails.root}/test/assets/suunto_sample.xml"
  end

  context "in general" do
    it "should fail with an invalid file" do
      DiveImporter.import(@invalid_file).should be_nil
    end

    it "should return an array of dives from a suunto sdm file" do
      Dive.stub!(:new_from_suunto_xml).and_return(Factory.create(:dive))
      dives =  DiveImporter.import(@suunto_sdm_file)
      dives.each do |dive|
        dive.should be_an_instance_of(Dive)
        dive.should be_new_record
      end
    end

    it "should return an array of dives from a suunto xml file" do
      Dive.stub!(:new_from_suunto_xml).and_return(Factory.create(:dive))
      dives =  DiveImporter.import(@suunto_xml_file)
      dives.length.should eql(1)
      dives.first.should be_an_instance_of(Dive)
      dives.first.should be_new_record

    end

  end

end
