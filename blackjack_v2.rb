require 'pry'
cards = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
suits = ['H', 'D', 'C', 'S']
deck = cards.product(suits)

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

puts "Welcome to play Blackjack!"
puts "What's your name?"
my_name = gets.chomp

begin
  a_shuffled_deck = deck.shuffle

  my_cards = []
  dealer_cards = []

  2.times do
    my_cards << a_shuffled_deck.pop
    dealer_cards << a_shuffled_deck.pop
  end

  my_cards_sum = calculate_sum(my_cards)
  dealer_cards_sum = calculate_sum(dealer_cards)

  puts "Dealer has: #{dealer_cards[0]} and #{dealer_cards[1]}, for a total of #{dealer_cards_sum}"
  puts "You have: #{my_cards[0]} and #{my_cards[1]}, for a total of: #{my_cards_sum}"
  puts ""

  if my_cards_sum == 21
    puts "Congratulations, you hit blackjack! You win!"
  else
    begin
      puts "What would you like to do? 1) hit 2) stay"
      hit_or_stay = gets.chomp
      unless ['1', '2'].include?(hit_or_stay)
        puts "Error: you must enter 1 or 2"
        next
      end

      if hit_or_stay == '2'
        puts "You choose to stay."
        break
      end

      new_card =  a_shuffled_deck.pop
      puts "Dealing card to player: :#{new_card}"
      my_cards << new_card
      my_cards_sum = calculate_sum(my_cards)

      if my_cards_sum == 21
        puts "Congratulations, you hit blackjack! You win!"
      elsif my_cards_sum > 21
        puts "Sorry, it looks like you busted!"
      end
    end while my_cards_sum < 21
  end

  if dealer_cards_sum == 21 && hit_or_stay == '2'
    puts "Sorry, dealer hit blackjack. You lose."
  elsif hit_or_stay == '2'
    begin
      new_card = a_shuffled_deck.pop
      puts "Dealing new card for dealer:#{new_card}"
      dealer_cards << new_card
      dealer_cards_sum = calculate_sum(dealer_cards)

      if dealer_cards_sum == 21
        puts "Sorry, dealer hit blackjack. You lose."
      elsif dealer_cards_sum > 21
        puts "Congratulations, dealer busted! You win!"
      end
    end while dealer_cards_sum < 17
  end

  if hit_or_stay == '2' && dealer_cards_sum < 21
    puts "Dealer's cards:"
    dealer_cards.each do |card|
      puts "=> #{card}"
    end
    puts ""

    puts "Your cards:"
    my_cards.each do |card|
      puts "=> #{card}"
    end
    puts ""

    if my_cards_sum > dealer_cards_sum
      puts "you win!"
    elsif my_cards_sum < dealer_cards_sum
      puts "you lose!"
    else
      puts "It's a tie!"
    end
  end
  puts "#{my_name},once_agian?(y/n)"
  once_again = gets.chomp

end while once_again == 'y'
