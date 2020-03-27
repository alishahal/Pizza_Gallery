require_relative './p_readyforcheckout.rb'
require 'pry'

# creates user order and returns users cart
def create_order(pizza)
    users_pizza = Pizza.find_by(pizza_name: pizza)
    current_user = User.find_by(name: $name_input)
    users_cart = Cart.find_or_create_by(user_id: current_user.id)
    users_order = Order.create(pizza_id: users_pizza.id, cart_id: users_cart.id)
    # users_cart
end

# # if we pass a name also in the previous method, can we pull from that and delete this method
def find_user_cart(name)
    current_user = User.find_by(name: name)
    users_cart = Cart.find_or_create_by(user_id: current_user.id)
    users_cart
end

# returns an array of items for user
def cart_orders(cart)
    cart_items = []
    cart.orders.each do |order|
        cart_items << order.pizza.pizza_name
    end
end

def get_pizza_description(name)
    pizza = Pizza.find_by(pizza_name: name)
    pizza.description
end

def buy_pizza
  pizza_choice = $prompt.select("Select a pizza from the list", ["Cheese","Hawaiian","Pepperoni","Supreme Pizza","Greek Pizza","Vegeterian Pizza"])
  case pizza_choice
      when "Cheese"
          create_order("Cheese")
      when "Hawaiian"
          create_order("Hawaiian")
      when "Pepperoni"
          create_order("Pepperoni")
      when "Supreme Pizza"
          create_order("Supreme Pizza")
      when "Greek Pizza"
          create_order("Greek Pizza")
      when "Vegeterian Pizza"
          create_order("Vegeterian Pizza")
  end
end

def users_cart_item
  users_own_cart = find_user_cart($name_input)
  all_cart_orders = cart_orders(users_own_cart)
  cart_total = 0
  cart_items = []
  all_cart_orders.each do |order|
      cart_items << (order.pizza.pizza_name)
      cart_total += order.pizza.price
  end

  if users_own_cart == nil
      puts "Your cart is empty"
  else
      if cart_items.length == 0
          puts "Your cart is empty"
      else
          puts "Items currently in your cart: #{cart_items.join(", ")}"
          puts "Your total is: #{cart_total}"
      end
  end
end

def cart_choices
  cart_choice = $prompt.select("What would you like to do?", ["Remove items","View pizza description","Ready_for_checkout"])
  if cart_choice == "Remove items"
    users_own_cart = find_user_cart($name_input)
    all_cart_orders = cart_orders(users_own_cart)
    cart_total = 0
    cart_items = []
    all_cart_orders.each do |order|
        cart_items << (order.pizza.pizza_name)
        cart_total += order.pizza.price
    end
      if cart_items.length != 0
      remove_choice = $prompt.select("What would you like to remove", cart_items)
          puts "Item removed"
          removed_pizza = all_cart_orders.select{|order| order.pizza.pizza_name == remove_choice}.shift
          remaining_order = all_cart_orders.reject{|order| order.pizza.pizza_name if order == removed_pizza}
          removed_pizza_price = removed_pizza.pizza.price
          cart_total -= removed_pizza_price
          cart_items = remaining_order.to_a.map{|order| order.pizza.pizza_name}
          removed_pizza.destroy
      else
          puts "Nothing to remove"
      end
  elsif cart_choice == "View pizza description"
      pizza_descript = $prompt.select("Select a pizza", ["Pepperoni","Hawaiian","Cheese","Supreme Pizza","Greek Pizza","Vegeterian Pizza"])
      case pizza_descript
          when "Pepperoni"
              puts get_pizza_description("Pepperoni")
              buy_pizza
              cart_choices
          when "Hawaiian"
              puts get_pizza_description("Hawaiian")
              buy_pizza
              cart_choices
          when "Cheese"
              puts get_pizza_description("Cheese")
              buy_pizza
              cart_choices
          when "Supreme Pizza"
              puts get_pizza_description("Supreme Pizza")
              buy_pizza
              cart_choices
          when "Greek Pizza"
              puts get_pizza_description("Greek Pizza")
              buy_pizza
              cart_choices
          when "Vegeterian Pizza"
              puts get_pizza_description("Vegeterian Pizza")
              buy_pizza
              cart_choices
      end
   elsif cart_choice == "Ready_for_checkout"
      ready_for_checkout?
  end
  # buy_pizza_or_view_cart
end

def view_cart
  users_own_cart = find_user_cart($name_input)
  all_cart_orders = cart_orders(users_own_cart)
  cart_total = 0
  cart_items = []
  all_cart_orders.each do |order|
      cart_items << (order.pizza.pizza_name)
      cart_total += order.pizza.price
  end
  if users_own_cart == nil
      puts "Your cart is empty"
  else
      if cart_items.length == 0
          puts "Your cart is empty"
      else
          puts "Items currently in your cart: #{cart_items.join(", ")}"
          puts "Your total is: #{cart_total}"
      end
  end
end

def buy_pizza_or_view_cart
    user_choice = $prompt.select("What do you want to do?", ["Buy a pizza","View my cart"])
    if user_choice == "Buy a pizza"
      buy_pizza
      users_cart_item
      cart_choices
    end
  if user_choice == "View my cart"
      view_cart
      cart_choices
  end
end
