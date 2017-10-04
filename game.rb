#!/usr/bin/env ruby
load 'pyscho.rb'

if ARGV.size < 2
  where = ARGV.size == 0 ? "Input" : "Output"
  raise ArgumentError.new("#{where} no valid file found.")
end

input_file = File.open(ARGV[0])
output_file = File.open(ARGV[1], "w")

input_file.read.split("\n").each do |line|
  line = line.split(" ")
  game = Pyscho.new(line[0, 5], line[5, 5])
  hand, deck, best_hand = game.cards_in_hand.join(' '), game.cards_in_deck.join(' '), game.best_hand
  output_file.write "Hand: #{hand} Deck: #{deck} Best hand: #{best_hand}\n"
end