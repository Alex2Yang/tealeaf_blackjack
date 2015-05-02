# 1.dealer and player both get two cards first
# 2.player go first, choose "hit" or "stay"
# case choose
# when hit
# "busted" if sum >21
# "win"   if sum ==21
# choose "hit" or "stay" again
# when stay
# save player's total value,then turn to the dealer
#
# dealer
# continue "hit" until sum of dealer >= 17
# player win if sum of dealer > 21
# dealer win if sum of dealer == 21
# compare sums and higher value win if dealer choose stay

suits = ["H","D","C","S"]
CARDS = {'A'=>[1,11], '2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6,
         '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'J'=>10, 'Q'=>10, 'K'=>10}
deck = CARDS.keys.product(suits)

def say_cards_and_sum(cards, sum, name)
  puts "#{name}'s cards is #{cards},and total value is #{sum}."
end

def clean_suit(cards)
  cards.map {|i| i.first}
end

def calculate_the_sum(cards)
  player_cards = clean_suit(cards)
  max_value = 0
  min_value = 0
  player_cards.each do |i|
    if i == 'A'
      card_min_value,card_max_value = CARDS[i]
    else
      card_min_value = card_max_value = CARDS[i]
    end
    max_value += card_max_value
    min_value += card_min_value
  end
  [min_value,max_value]
end

def sum_equal_to_21?(cards)
  if calculate_the_sum(cards).include?(21)
    puts "cards is #{cards}."
    puts "Sum equal to 21."
    true
  else
    false
  end
end

def is_busted?(cards)
  if calculate_the_sum(cards).first > 21
    puts "Cards is #{cards}."
    puts "Sum is greater than 21!"
    true
  else
    false
  end
end

def dealer_choice(cards)
  stay = 's'
  hit = 'h'
  min_value,max_value = calculate_the_sum(cards)
  case
  when max_value == 17 || min_value == 17 then stay
  when max_value < 17 then hit
  when max_value > 17 && max_value < 21 then stay
  when max_value > 21 && min_value < 17 then hit
  when min_value < 21 && min_value > 17 then stay
  end
end

puts "Welcome to Blackjack!"
puts "What's your name?"
player_name = gets.chomp
puts "Hi,#{player_name}"

loop do
  puts "=================================="
  puts "|           Game Begin           |"
  puts "=================================="

  shuffled_deck = deck.shuffle
  dealer_cards = []
  player_cards = []

  2.times do
    dealer_cards << shuffled_deck.pop
    player_cards << shuffled_deck.pop
  end

  puts "Your cards is #{player_cards}"
  if sum_equal_to_21?(player_cards)
    puts "#{player_name},you win!"
  else
    puts "#{player_name},you can choose hit or stay:(h/s)"
    player_choice = gets.chomp
    while player_choice == 'h'
      player_cards << deck.pop
      puts "You get a card #{player_cards.last},all your cards is #{player_cards}"
      if sum_equal_to_21?(player_cards)
        puts "#{player_name},you win!"
        break
      end
      if is_busted?(player_cards)
        puts "#{player_name},you lose!"
        break
      end
      puts "Hit or stay:(h/s)"
      player_choice = gets.chomp
    end
  end

  if sum_equal_to_21?(dealer_cards)
    puts "Dealer win!"
  elsif player_choice == 's'
    while dealer_choice(dealer_cards) == 'h'
      puts "Dealer choose to stay and gets a new card."
      dealer_cards << deck.pop
      if sum_equal_to_21?(dealer_cards)
        puts "Dealer's cards is #{dealer_cards}"
        puts "Dealer win!"
        break
      end
      if is_busted?(dealer_cards)
        puts "Dealer's cards is #{dealer_cards}"
        puts "Dealer lose,#{player_name},you win!"
        break
      end
    end
  end

  if player_choice == 's' && dealer_choice(dealer_cards) == 's'
    puts 'You and dealer both choose to stay,let\'s compare.'
    player_cards_sum = calculate_the_sum(player_cards).select {|i| i < 21}.max
    dealer_cards_sum = calculate_the_sum(dealer_cards).select {|i| i >= 17 && i < 21}.first
    if player_cards_sum > dealer_cards_sum
      say_cards_and_sum(player_cards,player_cards_sum,player_name)
      say_cards_and_sum(dealer_cards,dealer_cards_sum,'Dealer')
      puts "So,#{player_name} win!"
    elsif player_cards_sum < dealer_cards_sum
      say_cards_and_sum(player_cards,player_cards_sum,player_name)
      say_cards_and_sum(dealer_cards,dealer_cards_sum,'Dealer')
      puts "So,dealer win!"
    else
      puts "Dealer's cards is #{dealer_cards}"
      puts "It's a tie!"
    end
  end

  puts "=================================="
  puts "|           Game Over            |"
  puts "=================================="

  puts "Once Again?"
  once_again = gets.chomp
  break if once_again == 'n'
end
