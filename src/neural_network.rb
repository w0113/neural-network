#!/usr/bin/env ruby

require_relative "utils/data.rb"
require_relative "neural_network/feedforward.rb"

DATA_DIR = File.expand_path("../..", __FILE__) + "/data/"

FILE_TEST_IMAGES = DATA_DIR + "t10k-images-idx3-ubyte"
FILE_TEST_LABELS = DATA_DIR + "t10k-labels-idx1-ubyte"
FILE_TRAIN_IMAGES = DATA_DIR + "train-images-idx3-ubyte"
FILE_TRAIN_LABELS = DATA_DIR + "train-labels-idx1-ubyte"

printf "Loading Images... "
#train_images = Utils::Data.load(FILE_TRAIN_IMAGES, FILE_TRAIN_LABELS)
#test_images = Utils::Data.load(FILE_TEST_IMAGES, FILE_TEST_LABELS)
puts "finished"
nn = NeuralNetwork::Feedforward.new [28 * 28, 30, 10]
nn.update_mini_batch(nil, nil)
#gc_wheights, _ = nn.backpropagation(test_images.first.vpixels, test_images.first.vlabel)
#puts gc_wheights.last.column_size, gc_wheights.last.row_size
puts "finished"

