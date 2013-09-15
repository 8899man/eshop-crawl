# encoding: utf-8
require "digest/md5"
require 'carrierwave/processing/mini_magick'

class ImageUploader < CarrierWave::Uploader::Base
  #include CarrierWave::Compatibility::Paperclip

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
    #"image/items"
  #end
  def store_dir
    "u/#{model.created_at.strftime '%Y%m'}"
  end



  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  def default_url
    ["noface",version_name
    ].compact.join('_') + ".gif"
  end



  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end
  #process :resize_to_limit => [1280, 6000]

  version :thumb do
    process :resize_to_fill => [120, 120]
  end

  version :list do
    process :resize_to_fill => [200, 200]
  end

  version :pin do
    process :resize_to_limit => [236, 999999999]
  end


  #version :android do
    #process :resize_to_fill => [400, 400]
  #end

  version :show do
    process :resize_to_limit => [590, 999999999]
  end

  def image
    begin
      @image ||= MiniMagick::Image.open(file.path)
    rescue
      @image ||= {'width'=> 0,'height'=> 0}
    end
    @image
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end
end
