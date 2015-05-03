cards = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
suits = %w(H D C S)
deck = cards.product(suits)
BLACKJACK = 21

def dealing_cards(deck, hand)
  new_card = deck.pop
  hand[:cards] << new_card

  if hand[:cards].length > 2
    puts "Dealing #{new_card} card to #{hand[:name]}."
  end

end

def deal_initial_2_cards(deck, *hands)
  2.times do
    hands.each {|hand| dealing_cards(deck, hand)}
  end

  dealer_hand = hands.select {|hand| hand[:name] == 'dealer'}.first
  dealer_hand[:mask_card] = dealer_hand[:cards].last

end

def calculate_sum(hand)
  sum = 0
  cards_without_suit = hand[:cards].map{|card| card[0]}

  cards_without_suit.each do |card|
    if card == 'A'
      sum += 11
    elsif ['J', 'Q', 'K'].include?(card)
      sum += 10
    else
      sum += card.to_i
    end
  end

  sum -= cards_without_suit.count('A') * 10  if sum > 21
  sum
end

def evaluate_hand(hand)
  if calculate_sum(hand) == BLACKJACK
    puts "Congratulations,#{hand[:name]} hit blackjack! #{hand[:name]} win!"
  elsif calculate_sum(hand) > BLACKJACK
    puts "Sorry, #{hand[:name]} busted!"
  end
end

def player_turn(hand, deck)
  cards_sum = calculate_sum(hand)
  evaluate_hand(hand)

  while cards_sum < BLACKJACK
    puts "What would you like to do? 1) hit 2) stay"
    hit_or_stay = gets.chomp

    unless ['1', '2'].include?(hit_or_stay)
      puts "Error: you must enter 1 or 2"
      next
    end

    if hit_or_stay == '2'
      puts "#{hand[:name]} choose to stay."
      break
    end

    dealing_cards(deck, hand)
    cards_sum = calculate_sum(hand)
    evaluate_hand(hand)
  end
end

def dealer_turn(hand, deck)
  cards_sum = calculate_sum(hand)
  evaluate_hand(hand)

  while cards_sum < 17
    dealing_cards(deck, hand)
    sleep 1
    cards_sum = calculate_sum(hand)
    evaluate_hand(hand)
  end
end

def display_board(show_mask_card = false, *hands)
  system "clear"
  puts "----------- BlackJack -----------------"

  hands.each do  |hand|
    puts ""
    puts "#{hand[:name]}'s cards:"
    hand[:cards].each do |card|
      if !show_mask_card &&
          hand[:name] == 'dealer' &&
          hand[:mask_card] == card
        card = ['X', 'X']
      end
      puts "=> #{card}"
    end
    puts ""
  end

end

def compare_hands(hand1, hand2)
  player1_cards_sum = calculate_sum(hand1)
  player2_cards_sum = calculate_sum(hand2)
  puts "Sum of #{hand1[:name]} is #{player1_cards_sum},"
  puts "Sum of #{hand2[:name]} is #{player2_cards_sum}."

  if player1_cards_sum > player2_cards_sum
    puts "So,#{hand1[:name]} win!"
  elsif  player1_cards_sum < player2_cards_sum
    puts "So,#{hand2[:name]} win!"
  else
    puts "It's a tie!"
  end

end

system "clear"
puts "Welcome to play Blackjack!"
puts "What's your name?"
my_name = gets.chomp
dealer_name = 'dealer'

loop do
  new_deck = (deck * 4).shuffle
  my_hand = {name:my_name, cards:[]}
  dealer_hand = {name:dealer_name, cards:[]}

  deal_initial_2_cards(new_deck, my_hand, dealer_hand)

  display_board(show_mask_card = false, my_hand, dealer_hand)
  player_turn(my_hand, new_deck)

  if calculate_sum(my_hand) < BLACKJACK
    display_board(show_mask_card = true, my_hand, dealer_hand)
    dealer_turn(dealer_hand, new_deck)

    if (17..20).include?(calculate_sum(dealer_hand))
      puts "dealer choose to stay"
      sleep 1
      display_board(show_mask_card = true, my_hand, dealer_hand)
      compare_hands(my_hand, dealer_hand)
    end

  end

  puts "#{my_name},once_agian?(y/n)"
  once_again = gets.chomp
  break if once_again == 'n'

end
