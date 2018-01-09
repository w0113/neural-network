
require "distribution"
require "matrix"

module Digits

  class NeuralNetwork

    def initialize(layout)
      @wheights = []
      @bias = []

      grng = Distribution::Normal.rng
      layout[0..-2].zip(layout[1..-1]).each do |inputs, num_of_neurons|
        @wheights << Matrix.build(num_of_neurons, inputs){grng.call}
        @bias << Vector.elements(Array.new(num_of_neurons){grng.call})
      end
    end

    def feed_forward(activations)
      as, zs = [], []
      a = Vector.elements activations
      as << a
      zs << nil
      @wheights.zip(@bias).each do |w, b|
        z = w * a + b
        a = z.map{|v| sig v}
        as << a
        zs << z
      end
      return [as, zs]
    end

    def backpropagation(activations, correct)
      as, zs = feed_forward activations

      errors = [(as.last - correct).map2(zs.last.map{|v| sig_prime v}){|a, b| a * b}]
      (as.size - 2).downto(1).each do |i|
        errors.unshift((@wheights[i].transpose * errors.first).map2(zs[i].map{|v| sig_prime v}){|a, b| a * b})
      end
      
    end

    def sig(t)
      return 1.0 / (1.0 + Math.exp(-t))
    end

    def sig_prime(t)
      return sig(t) * (1 - sig(t))
    end
  end
end

