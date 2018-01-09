require "chunky_png"
require "matrix"

module Utils

  class Image

    attr_reader :label, :width, :height, :pixels, :vpixels, :vlabel
    
    def initialize(label, width, height, pixels)
      @label, @width, @height, @pixels = label, width, height, pixels

      @vpixels = Vector.elements(pixels.map do |v|
        nv = v.to_f / 255.0
        raise "Pixel value out of range" unless (0.0..1.0).include?(nv)
        next nv
      end)
      
      raise "Label out of range" unless (0..9).include?(label)
      @vlabel = Array.new 10, 0.0
      @vlabel[label] = 1.0
      @vlabel = Vector.elements @vlabel
    end

    def to_png(path = nil)
      result = nil
       
      png = ChunkyPNG::Image.new width, height
      pixels.each_with_index do |p, i|
        gsc = 255 - p
        png[(i % width), (i / width)] = ChunkyPNG::Color.rgb gsc, gsc, gsc
      end

      if path
        png.save path
      else
        result = png.to_blob
      end

      return result
    end
  end
end

