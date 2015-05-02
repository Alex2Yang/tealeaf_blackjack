cards = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
suits = %w(H D C S)
deck = cards.product(suits)

def display_start_or_end(msg)
  puts ""
  puts "=================================="
  puts "            Game #{msg}              "
  puts "=================================="
  puts ""
end

def calculate_sum(cards)
  sum = 0
  cards_without_suit = cards.map{|card| card[0]}

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

def player_turn(cards, deck, name)
  cards_sum = calculate_sum(cards)
  if cards_sum == 21
    puts "Congratulations, #{name} hit blackjack! #{name} win!"
  end

  while_end = name == 'Dealer' ? 17 : 21

  begin
    unless name == 'Dealer'
      puts "What would you like to do? 1) hit 2) stay"
      hit_or_stay = gets.chomp
      unless ['1', '2'].include?(hit_or_stay)
        puts "Error: you must enter 1 or 2"
        next
      end

      if hit_or_stay == '2'
        puts "#{name} choose to stay."
        break
      end
    end

    new_card =  deck.pop
    puts "Dealing card to #{name}: :#{new_card}"
    cards << new_card
    cards_sum = calculate_sum(cards)

    if cards_sum == 21
      puts "Congratulations,#{name} hit blackjack! #{name} win!"
    elsif cards_sum > 21
      puts "Sorry, #{name} busted!"
    end
  end while cards_sum <  while_end
end

def display_cards(cards,name)
  puts "#{name}'s cards:"
  cards.each do |card|
    puts "=> #{card}"
  end
  puts ""
end

def compare_hands(player1_cards,player1_name,player2_cards,player2_name)
  display_cards(player1_cards, player1_name)
  display_cards(player2_cards, player2_name)
  player1_cards_sum = calculate_sum(player1_cards)
  player2_cards_sum = calculate_sum(player2_cards)

  if player1_cards_sum > player2_cards_sum
    puts "#{player1_name} win!"
  elsif  player1_cards_sum < player2_cards_sum
    puts "#{player2_name} win!"
  else
    puts "It's a tie!"
  end
end

puts "Welcome to play Blackjack!"
puts "What's your name?"
my_name = gets.chomp
dealer_name = 'Dealer'

begin
  display_start_or_end('Start')

  new_deck = (deck * 4).shuffle
  my_cards = []
  dealer_cards = []

  2.times do
    my_cards << new_deck.pop
    dealer_cards << new_deck.pop
  end

  display_cards(my_cards,my_name)
  display_cards(dealer_cards,dealer_name)

  player_turn(my_cards,new_deck,my_name)
  player_turn(dealer_cards,new_deck,dealer_name) if calculate_sum(my_cards) < 21

  if calculate_sum(my_cards) < 21 &&
     (17..20).include?(calculate_sum(dealer_cards))
    compare_hands(my_cards,my_name,dealer_cards,dealer_name)
  end

  display_start_or_end('Over')

  puts "#{my_name},once_agian?(y/n)"
  once_again = gets.chomp

end while once_again == 'y'
