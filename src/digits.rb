#!/usr/bin/env ruby

require_relative "digits/data.rb"
require_relative "digits/neural_network.rb"

DATA_DIR = File.expand_path("../..", __FILE__) + "/data/"

FILE_TEST_IMAGES = DATA_DIR + "t10k-images-idx3-ubyte"
FILE_TEST_LABELS = DATA_DIR + "t10k-labels-idx1-ubyte"
FILE_TRAIN_IMAGES = DATA_DIR + "train-images-idx3-ubyte"
FILE_TRAIN_LABELS = DATA_DIR + "train-labels-idx1-ubyte"

printf "Loading Images... "
images = Digits::Data.load(FILE_TRAIN_IMAGES, FILE_TRAIN_LABELS)
puts "finished"
nn = Digits::NeuralNetwork.new [28 * 28, 30, 10]
#p nn.process images.first.floats
nn.backpropagation(images.first.vpixels, images.first.vlabel)
puts "finished"

