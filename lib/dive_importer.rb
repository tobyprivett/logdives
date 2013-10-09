# returns array of Dive objects or nil
class DiveImporter

  PROCESSORS = ["suunto_sdm_zip", "suunto_xml"]


  def DiveImporter.import(file_path)
    @imported = false
    @file_path = file_path
    @dives = []
    PROCESSORS.each do |processor|
      eval(processor)
      return @dives if @imported
    end
    nil
  end

  private

  class << self

    def suunto_xml
      dive = SuuntoImporter.new_from_xml(@file_path)
      return if dive.nil?
      @dives << dive
      @imported = true
    end

    def suunto_sdm_zip
      directory = Unzipper.unzip(@file_path)
      return unless directory

      Dir.foreach(directory) do |file|
        next unless file.include?('.xml')

        dive = SuuntoImporter.new_from_xml(File.join(directory, file))
        @dives << dive unless dive.nil?
        File.unlink(File.join(directory, file))
      end

      @imported = true
      Dir.unlink(directory)
    end
  end
end

class SuuntoImporter
  def SuuntoImporter.new_from_xml(file_path)
    # a sample file_path = "#{Rails.root}/test/assets/suunto_sample.xml"
    f = Nokogiri::XML(File.open(file_path))

    if f.css("SUUNTO").present?

      d = Dive.new :dive_date => (f.css("DATE").text || Date.today).to_date,
      :max_depth_amount => f.css("MAXDEPTH").text,
      :depth_unit => :metric,
      :average_depth_amount => f.css("MEANDEPTH").text,
      :sample_interval => f.css("SAMPLEINTERVAL").text,
      :title => f.css("LOGTITLE").text,
      :location => f.css("SITE").text + ', ' + f.css("LOCATION").text,
      :weather => f.css("WEATHER").text,
      :visibility => f.css("WATERVISIBILITY").text,
      :air_temperature => f.css("AIRTEMP").text,
      :water_temperature_at_depth => f.css("WATERTEMPMAXDEPTH").text,
      :water_temperature_on_surface => f.css("WATERTEMPATEND").text,
      :notes => f.css("LOGNOTES").text,

      :samples => f.css("SAMPLE").map{ |sample| [sample.css('SAMPLETIME').text, sample.css('DEPTH').text] }

      return d if d.valid?
    end
  end
end
