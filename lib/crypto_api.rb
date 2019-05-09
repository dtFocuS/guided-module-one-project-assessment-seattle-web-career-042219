require_relative '../app/models/crypto'
require_relative '../app/models/investment'
require_relative '../app/models/user'
require 'pry'

def play_game
  system "clear"
  print "\e[8;1000;1000t"
  welcome if !$TEST_MODE
  current_user = get_user
  menu(current_user)
end



def welcome
  system "clear"
  aa = Artii::Base.new :font => 'univers'
  bb = Artii::Base.new :font => 'doh'
  cc = Artii::Base.new :font => 'larry3d'
  dd = Artii::Base.new :font => 'banner3'
  puts bb.asciify('Welcome to')
  sleep(1)
  system "clear"
  puts aa.asciify(" CRYPTO GAME")
  sleep(1)
  puts bb.asciify("WANT TO INVEST?")
  puts cc.asciify("    $$$")
  sleep(1)
  system "clear"
  if !$IS_LITE_MODE
    Catpix::print_image "lib/img/Resize.png",
    :limit_x => 1.0,
    :limit_y => 0,
    :center_x => true,
    :center_y => true,
    :bg => "white",
    :bg_fill => true
    puts
  end
end

def get_user
  print "What's your name?".center(`tput cols`.to_i)
  print "".center(95)
  name_response = gets.chomp
  current_user = nil
  if !User.find_by(name: name_response)
    current_user = User.create(name: name_response)
  else
    current_user = User.find_by(name: name_response)
  end
end

def menu(user)
  print "\e[8;1000;1000t"
  aa = Artii::Base.new :font => 'doom'
  puts aa.asciify("Let's invest some money?".center(110))
  puts
  puts aa.asciify("1.  Play a New Game ".center(125))
  user_input = gets.chomp
  if user_input == "1"
    start_game(user)
  else
    puts "Selection not recognized"
    system "clear"
  end
end



def start_game(user)
  system "clear"
  prompt = TTY::Prompt.new
  crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))

  puts ""
  puts "Here are the 2017 monthly #{crypto_chosen} price"


  prefix = "2017"

  #Crypto.where(name: crypto_chosen).where("date LIKE :prefix", prefix: "#{prefix}%").each do |coin|
  Crypto.find_by_year(crypto_chosen, prefix).each do |coin|
     #puts "#{Date::MONTHNAMES[coin.date.split("-")[1].to_i]} price is $#{coin.price}"
    coin.display
  end
  puts ""
  puts "Please answer yes or no to indicate whether or not you want to invest in a
  particular month starting from February of 2018 based on the trend of 2017"
  puts ""

  results_array = Crypto.find_by_year(crypto_chosen, "2018")
  results_array[0].display

  # puts "#{Date::MONTHNAMES[results_array[0].date.split("-")[1].to_i]} price is $#{results_array[0].price}"

  i = 1

  reports_array = []

  while i < 12
    print "Would you like to invest in the month of #{Date::MONTHNAMES[i + 1]}: "
    response = gets.chomp

    if response.downcase != "yes" && response.downcase != "no"
      puts "Please enter a valid response."
    else
      new_investment = Investment.create(response: response, user_id: user.id, crypto_id: results_array[i].id)
      if response.downcase == "yes"
        if results_array[i].price < results_array[i-1].price
          puts "Oops! The value went down in #{Date::MONTHNAMES[i]}. Price was #{results_array[i].price}."
          reports_array << false
        else
          puts "The value WENT UP!! Nice investment. Price was #{results_array[i].price}."
          reports_array << true
        end
        i += 1
      elsif response.downcase == "no"
        if results_array[i].price < results_array[i-1].price
          puts "The value went down!! Good job on not investing. Price was #{results_array[i].price}."
          reports_array << true
        else
          puts "Too bad. You would've made some money. Price was #{results_array[i].price}."
          reports_array << false
        end
        i += 1
      end
    end
  end

  puts "You've made #{reports_array.count(true)} good investments and #{reports_array.count(false)} bad investments!"
end







# puts "Welcome"
# print "Please enter your name: "
# name_response = gets.chomp
# current_user = nil
# if !User.find_by(name: name_response)
#   current_user = User.create(name: name_response)
# else
#   current_user = User.find_by(name: name_response)
# end



# prompt = TTY::Prompt.new
# crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))
# puts ""
# puts "Here are the 2017 monthly #{crypto_chosen} price"
#
#
# prefix = "2017"
# # Crypto.where(name: crypto_chosen).where("date LIKE :prefix", prefix: "#{prefix}%").each do |coin|
# Crypto.find_by_year(crypto_chosen, prefix).each do |coin|
#   # puts "#{Date::MONTHNAMES[coin.date.split("-")[1].to_i]} price is $#{coin.price}"
#   coin.display
# end
# puts ""
# puts "Please answer yes or no to indicate whether or not you want to invest in a
# particular month starting from February of 2018 based on the trend of 2017"
# puts ""
#
# results_array = Crypto.find_by_year(crypto_chosen, "2018")
#
# results_array[0].display
# #puts "#{Date::MONTHNAMES[results_array[0].date.split("-")[1].to_i]} price is $#{results_array[0].price}"
# i = 1
# reports_array = []
# while i < 12
#   print "Would you like to invest in the month of #{Date::MONTHNAMES[i + 1]}: "
#   response = gets.chomp
#   if response.downcase != "yes" && response.downcase != "no"
#     puts "Please enter a valid response."
#   else
#   #new_investment = Investment.create(response: response, user_id: current_user.id, crypto_id: results_array[i].id)
#     if response.downcase == "yes"
#       if results_array[i].price < results_array[i-1].price
#         puts "Oops! The value went down in #{Date::MONTHNAMES[i]}. Price was #{results_array[i].price}."
#         reports_array << false
#       else
#         puts "The value WENT UP!! Nice investment. Price was #{results_array[i].price}."
#         reports_array << true
#       end
#       i += 1
#     elsif response.downcase == "no"
#       if results_array[i].price < results_array[i-1].price
#         puts "The value went down!! Good job on not investing. Price was #{results_array[i].price}."
#         reports_array << true
#       else
#         puts "Too bad. You would've made some money. Price was #{results_array[i].price}."
#         reports_array << false
#       end
#       i += 1
#     end
#   end
#   puts ""
# end
# #Investment.destroy_all
# puts "You've made #{reports_array.count(true)} good investments and #{reports_array.count(false)} bad investments!"
