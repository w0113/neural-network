
require "distribution"
require "matrix"

module NeuralNetwork

  class Feedforward

    def initialize(layout)
      @wheights = []
      @bias = []

      grng = Distribution::Normal.rng
      layout[0..-2].zip(layout[1..-1]).each do |num_of_inputs, num_of_neurons|
        @wheights << Matrix.build(num_of_neurons, num_of_inputs){grng.call}
        @bias << Vector.elements(Array.new(num_of_neurons){grng.call})
      end
    end

    def process(activations)
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
      # Calculate the output of the neural network
      as, zs = process activations

      # Calculate the output error
      errors = [(as.last - correct).map2(zs.last.map{|v| sig_prime v}){|a, b| a * b}]
      # Backpropagate the error to the hidden layers
      (as.size - 2).downto(1).each do |i|
        errors.unshift((@wheights[i].transpose * errors.first).map2(zs[i].map{|v| sig_prime v}){|a, b| a * b})
      end
      
      # Calculate the gradient of the cost function for each bias vector and each wheight matrix
      gc_bias = errors
      gc_wheights = []
      errors.each_with_index do |e, i|
        gc_wheights << Matrix[*e.to_a.map{|v| (as[i] * v).to_a}]
      end

      # Return both in an array
      return [gc_wheights, gc_bias]
    end

    def update_mini_batch(batch, eta)
      delta_wheights = @wheights.map{|m| Matrix.build(m.row_size, m.column_size){0.0}}
      delta_bias = @bias.map{|v| Vector.elements(Array.new(v.size){0.0})}

      batch.each do |b|
        gc_wheights, gc_bias = backpropagation(b.vpixels, b.vlabel)
        delta_wheights.map.with_index{|m, i| m + gc_wheights[i]}
        delta_bias.map.with_index{|v, i| v + gc_bias[i]}
      end

      aeta = eta / batch.size.to_f
      @wheights.map!.with_index{|m, i| m - (delta_wheights[i] * aeta)}
      @bias.map!.with_index{|v, i| v - (delta_bias[i] * aeta)}
    end

    def sig(t)
      return 1.0 / (1.0 + Math.exp(-t))
    end

    def sig_prime(t)
      return sig(t) * (1 - sig(t))
    end
  end
end

