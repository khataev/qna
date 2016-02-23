# encoding: utf-8

# FileUploader class
class FileUploader < CarrierWave::Uploader::Base
  delegate :filename, to: :file, allow_nil: true

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
