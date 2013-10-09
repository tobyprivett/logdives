require 'zip/zipfilesystem'
require 'fileutils'

class Unzipper
  attr_accessor :zip_file_path, :to_folder_path

  def self.unzip( zip_file_path )

    @zip_file_path = zip_file_path
    @to_folder_path = @zip_file_path + '_extract'

    return if File.exists?( @zip_file_path ) == false

    if File.exists?( @to_folder_path ) == false
      FileUtils.mkdir( @to_folder_path )
    end

    zip_file = Zip::ZipFile.open( @zip_file_path )

    Zip::ZipFile.foreach( @zip_file_path ) do | entry |
      file_path = File.join(  @to_folder_path, entry.to_s )
      if File.exists?( file_path )
        FileUtils.rm( file_path )
      end
      zip_file.extract( entry, file_path )
    end
    return @to_folder_path

  rescue Zip::ZipError
    Dir.unlink(@to_folder_path)
    return false
  end
end

