#!/usr/bin/env ruby
# require 'pry'
class Pyscho
  
  attr_reader :cards_in_hand, :cards_in_deck

  FACES = %W{2 3 4 5 6 7 8 9 T J Q K A}
  SUITS = %W{S H D C}
  COMBOS = %W{highest-card one-pair two-pairs three-of-a-kind
            straight flush full-house four-of-a-kind straight-flush}

  def initialize(hand, deck)
    self.hand(hand)
    self.deck(deck)
    @simulatedHands = hand
  end

  def is_flush?
    @simulatedHands.map {|i| i[1]}.uniq.size.equal? 1
  end

  def is_straight?
    hand = @simulatedHands.map {|i| i[0]}
    hand.values_at(0,4) == %W{2 A}? hand[0,4] == FACES[0, 4] : hand == FACES[FACES.index(hand.first), 5]
  end

  def hand(cards)
    @cards_in_hand = cards if is_valid_cards?(cards)
  end

  def deck(cards)
    @cards_in_deck = cards if is_valid_cards?(cards)
  end

  def kinds?(types)
    counter = Hash.new(0)
    @simulatedHands.map {|i| i[0]}.each {|val| counter[val] += 1 }
    types.sort == counter.values.sort
  end
  
  def is_valid_cards?(cards)
    valid = cards.all? do |card|
      SUITS.include?(card[1]) && FACES.include?(card[0])
    end
    valid || ArgumentError.new('Invalid Cards')
  end

  def best_hand
    best_hand = 'highest-card'
    (0..@cards_in_hand.length).each do |card_number_in_hand|
      @cards_in_hand.combination(card_number_in_hand).each do |combination|
        combination.each_with_index {|buf,buf_index| @simulatedHands[@simulatedHands.index(buf)] = @cards_in_deck[buf_index]}
        @simulatedHands.sort! {|key,val| FACES.index(key[0]) <=> FACES.index(val[0]); }
        probable_best_hand = ('straight-flush' if is_straight? && is_flush?) ||
                 ('four-of-a-kind' if kinds? [4, 1]) ||
                 ('full-house' if kinds? [3, 2]) ||
                 ('flush' if is_flush?) ||
                 ('straight' if is_straight?) ||
                 ('three-of-a-kind' if kinds? [3, 1, 1]) ||
                 ('two-pairs' if kinds? [2, 2, 1]) ||
                 ('one-pair' if kinds? [2, 1, 1, 1]) ||
                 'highest-card'
        best_hand = probable_best_hand if COMBOS.index(probable_best_hand) > COMBOS.index(best_hand)
        return best_hand if best_hand.eql?('straight-flush')
        @simulatedHands = @cards_in_hand.dup
      end
    end
    best_hand
  end
end