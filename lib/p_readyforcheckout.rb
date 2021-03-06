require_relative './p_buy_view.rb'
require 'pry'

def validate_card_number?(user_card)
  user_card = user_card.to_s unless user_card.is_a? String
  /\A[+-]?\d+(\.[\d]+)?\z/.match user_card
end


def checkout
    loop do
        puts "Please enter your 10-digit Card Number:"
        cc_input = nil
        loop do
          cc_input = gets.strip
          break if validate_card_number?(cc_input)
          puts "That is not a number. Pls enter only 10 digit Card Number:"
        end

        if cc_input.length == 10
            current_user = User.find_by(name: $name_input)
            users_cart = Cart.find_by(user_id: current_user.id)
            cart_total = 0
            cart_items = []
            users_cart.orders.each do |order|
                cart_items << order.pizza.pizza_name
                cart_total += order.pizza.price
            end
            users_cart.orders.clear
            puts "Thank You for shopping Pizza Gallery, Come Again!"
            break
        else
            puts "Invalid Card Number"
        end
    end
end

def ready_for_checkout?
    loop do
      user_choice = $prompt.select("Ready for checkout?", ["Yes","No"])
      case user_choice
          when "No"
              buy_pizza_or_view_cart
          when "Yes"
              checkout
              break
            end
    end
end
