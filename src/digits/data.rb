require "chunky_png"

require_relative "image.rb"

module Digits

  module Data

    class Error < StandardError; end
    class ParserError < Error; end

    def self.load(images_path, labels_path)
      result = []
      File.open(images_path, "rb") do |fi|
        File.open(labels_path, "rb") do |fl|
          # Read file header of label file
          l_magic, l_num_of_labels = fl.read(8).unpack("l>*")
          raise ParserError, "Invalid label file" if l_magic != 2049
          
          # Read file header of image file
          i_magic, i_num_of_images, i_rows, i_cols = fi.read(16).unpack("l>*")
          raise ParserError, "Invalid image file" if i_magic != 2051

          # Check if we have the same amount of items
          if i_num_of_images != l_num_of_labels
            raise ParserError, "Number of items in image and label file do not match" 
          end

          # Read images and labels and store them in Image objects
          i_num_of_images.times do
            label = fl.getbyte
            pixels = fi.read(i_rows * i_cols).bytes
            result << Image.new(label, i_cols, i_rows, pixels)
          end
        end
      end
      return result
    end
  end
end

