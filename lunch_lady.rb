require 'pry'
class User
  attr_accessor :name, :wallet, :order

  def initialize(name, wallet = 10.00) #sets up a user with 'name' and defaults wallet to '10' unless specified
    @name = name
    @wallet = wallet
    @order = []
  end

  def clean_plate #called on @wallet >= total, from user.checkout
    @order = []
    luck = rand(10)
    if luck <= 3
      puts "You got food poisoning and died!"
      exit(0)
    elsif luck <= 4
      puts "You found $20 on the ground!"
      @wallet += 20.00
    elsif luck <= 6
      puts "You enjoyed the meal in a weird way."
    else
      puts "You enjoyed the meal."
    end
  end

  def hungry #called on @wallet < total, from user.checkout
    @order = []
    luck = rand(10)
    if luck <= 3
      puts "You found $5 in the lunch lady's beard!"
      @wallet += 5.00
    elsif luck <= 6
      puts "You have been blessed by the gods of cash. +$100"
      @wallet += 100.00
    end
  end

  def show_order #prints user order, called from user.checkout
    puts "You ordered:\n------------"
    @order.each {|item| puts "#{item.name}: #{item.price}" }
    total = @order.map(&:price).inject(:+)
    puts "------------\nYour total is: $#{'%.2f' % total}\n------------"
    return total
  end

  def checkout #called from LunchLady.order_up, reduces wallet, calls user.hungry OR user.clean_plate
    total = show_order
    if @wallet >= total
      @wallet -= total
      puts "Your new balance is: $#{@wallet}"
      clean_plate
    else
      puts "You don't have enough money!"
      hungry
    end
  end
end

class Food #object for foor item
  attr_accessor :name, :price

  def initialize(name, price) #no defaults, needs to be passed name(string) and price(float)
    @name = name
    @price = price
  end
end

class Menu #class for building menu and ordering food items
  attr_accessor :name, :foods

  def initialize(name, foods = []) #needs to be passed name for "#{name} Menu", and array of food objects
    @foods = foods
    @name = name
  end

  def show #called from LunchLady.order_up, prints menu name and items
    puts "--- #{@name} Menu ---"
    @foods.each_with_index do |food, i|
      puts "#{i + 1}) #{food.name} -- $#{food.price}"
    end
    puts "---------------"
  end

  def order #called from LunchLady.order_up after menu.show, takes order number and returns food object
    print "Please enter the number of the item you would like to order: "
    selection = gets.strip.to_i
    if selection <= @foods.length + 1
      return @foods[selection - 1]
    else
      puts "Invalid selection, try again (pick a number 1-#{@foods.length})"
      order
    end
  end
end

class LunchLady #main class, calls all other classes and methods, does not need to be instanciated
  def self.order_up #runs intro to cafeteria, prints menus, gets user order, and runs user.checkout
    puts "\nGreetings #{@user.name}! Welcome to the cafeteria.\n"

    @mains.show
    @user.order << @mains.order

    2.times do
      @sides.show
      @user.order << @sides.order
    end

    @user.checkout
  end

  def self.main #main body method, call LunchLady.main to build menus, create user, run program loop.
    main_items = [Food.new("Hot Dog", 3.00), Food.new("Meatloaf", 5.30), Food.new("Lobster", 15.00)]
    side_items = [Food.new("Macaroni", 2.25), Food.new("Beans", 1.00), Food.new("Salad", 2.75)]

    @mains = Menu.new("Main", main_items)
    @sides = Menu.new("Side", side_items)

    print "Who are you? "
    name = gets.strip
    print "How much do you have? "
    wallet = gets.strip.to_f
    @user = User.new(name, wallet)

    while true
      order_up
      puts "Still hungry? (y/n)"
      exit(0) if gets.strip == 'n'
    end
  end
end

LunchLady.main #main execution
