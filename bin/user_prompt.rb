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
  name_response = gets.chomp.downcase
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

  puts ("Let's invest some money?".center(110))
  puts
  puts ("1.  Play a New Game ".center(125))
  puts ("2.  Choose a Different Coin ".center(125))
  puts ("3.  Show Previous Result ".center(125))
  puts ("4.  Delete Account Data ".center(125))
  puts ("5. Quit Game ".center(125))
  user_input = gets.chomp
  if user_input == "1" || user_input == "2"
    start_game(user)
    sleep(5)
    system "clear"
    menu(user)
  elsif user_input == "3"
    if !Investment.find_by(user_id: user.id)
      puts "You haven't played any game yet."
    else
      hash = {}
      Investment.where(user_id: user.id).each do |investment|
      if !hash.include?(Crypto.find_by(id: investment.crypto_id).name)
        hash[Crypto.find_by(id: investment.crypto_id).name] = []
        #hash[Crypto.find_by(investment.crypto_id).name] << investment.result
      end
      hash[Crypto.find_by(id: investment.crypto_id).name] << investment.result
      end
      puts "You've made #{hash.values[0].count("good")} good investments and #{hash.values[0].count("bad")} bad investments on #{hash.keys[0]}!"
    end
    sleep(3)
    menu(user)
  elsif user_input == "4"

    if User.find_by(id: user.id)
      if Investment.where(user_id: user.id)
        invest_entry = Investment.where(user_id: user.id)
        invest_entry.each {|investment| investment.destroy}
      end
      user_data = User.find_by(id: user.id)
      user_data.destroy
      puts "User data wiped"
    end
    sleep(3)
    system "clear"
    play_game
  elsif user_input == "5"
    puts "Exit Game."
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

  cryptos_array = Crypto.find_by_year(crypto_chosen, "2018")
  cryptos_array[0].display

  # puts "#{Date::MONTHNAMES[cryptos_array[0].date.split("-")[1].to_i]} price is $#{cryptos_array[0].price}"

  i = 1

  while i < 12
    print "Would you like to invest in the month of #{Date::MONTHNAMES[i + 1]}: "
    response = gets.chomp
    result = ""
    if response.downcase != "yes" && response.downcase != "no"
      puts "Please enter a valid response."
    else
      #new_investment = Investment.create(response: response, user_id: user.id, crypto_id: cryptos_array[i].id)
      if response.downcase == "yes"
        if cryptos_array[i].price < cryptos_array[i-1].price
          puts "Oops! The value went down in #{Date::MONTHNAMES[i + 1]}. Price was #{cryptos_array[i].price}."
          result = "bad"
        else
          puts "The value WENT UP!! Nice investment. Price was #{cryptos_array[i].price}."
          result = "good"
        end
        #Investment.create(response: response, user_id: user.id, crypto_id: cryptos_array[i].id)
        #i += 1
      elsif response.downcase == "no"
        if cryptos_array[i].price < cryptos_array[i-1].price
          puts "The value went down!! Good job on not investing. Price was #{cryptos_array[i].price}."
          result = "good"
        else
          puts "Too bad. You would've made some money. Price was #{cryptos_array[i].price}."
          result = "bad"
        end
        #i += 1
      end
      if !Investment.where(user_id: user.id).find_by(crypto_id: cryptos_array[i].id)
        Investment.create(response: response, user_id: user.id, crypto_id: cryptos_array[i].id, result: result)
      else
        old_investment = Investment.where(user_id: user.id).find_by(crypto_id: cryptos_array[i].id)
        old_investment.update(response: response, user_id: user.id, crypto_id: cryptos_array[i].id, result: result)
      end
      i += 1
    end
  end
  #Investment.destroy_all
  reports_array = reports(cryptos_array, user)
  #previous_results(reports_array)
  #reports_array = []
  #cryptos_array[1..11].each do |crypto|
    #reports_array << Investment.where(user_id: user.id).find_by(crypto_id: crypto.id).result
  #end
  #Investment.destroy_all
  #puts "You've made #{reports_array.count("good")} good investments and #{reports_array.count("bad")} bad investments!"
end

def reports(cryptos, user)
  reports_array = []
  cryptos[1..11].each do |crypto|
    reports_array << Investment.where(user_id: user.id).find_by(crypto_id: crypto.id).result
  end
  puts "You've made #{reports_array.count("good")} good investments and #{reports_array.count("bad")} bad investments!"
  reports_array
end

#def previous_results(reports_array)
  #reports_array
#end
