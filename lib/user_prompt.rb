require_relative '../app/models/crypto'
require_relative '../app/models/investment'
require_relative '../app/models/user'
require 'pry'
require 'tty-cursor'
require 'tty-screen'

@cursor = TTY::Cursor
@size = TTY::Screen.size # => [height, width]
@height = @size[0]
@width = @size[1]

def move_cursor_to_required_coordinates(text)
  x = (@size[1] - text.length) / 2
  y = (@size[0]) / 2
  print @cursor.move_to(x, y)
end

def centered_text(text)
  move_cursor_to_required_coordinates(text)
  puts text
end


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
  bb = Artii::Base.new :font => 'mini'
  cc = Artii::Base.new :font => 'larry3d'
  dd = Artii::Base.new :font => 'banner3'

  puts aa.asciify("            Welcome to").yellow

  sleep(2)

  puts aa.asciify("         CRYPTO GAME").yellow
  sleep(3)
  system "clear"
  puts bb.asciify("                                        WANT TO INVEST?").yellow
  puts aa.asciify("                      $$$").yellow
  sleep(3)
  system "clear"
  if !$IS_LITE_MODE
    Catpix::print_image "lib/img/bestsize.png",
    :limit_x => 1.0,
    :limit_y => 0,
    :center_x => true,
    :center_y => true
    puts
  end
end

def get_user
  print "What's your name?".center(`tput cols`.to_i)
  print "".center(103)
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
  puts
  puts

  puts aa.asciify("                                                              Let's invest some money?").yellow
  puts
  puts aa.asciify("                                                               1.  Play a New Game").yellow
  puts aa.asciify("                                                               2.  Choose a Different Coin").yellow
  puts aa.asciify("                                                               3.  Show Previous Result").yellow
  puts aa.asciify("                                                               4.  Delete Account Data").yellow
  puts aa.asciify("                                                               5.  Quit Game").yellow


  print "   What's your choice? Pick a number and hit enter".center(`tput cols`.to_i)
  print "".center(105)
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
      hash.each do |coin, results|
      puts "                                                                            You've made #{results.count("good")} good investments and #{results.count("bad")} bad investments on #{coin}!"
      end
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
    puts "                                                                                                     Exit Game."
  else
    puts "Selection not recognized"
    sleep(3)
    system "clear"
    menu(user)
  end
end






def start_game(user)
  system "clear"
 #  prompt = TTY::Prompt.new
 #  # crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))
 #  crypto_chosen = prompt.select("                                                                           Choose your crypto:") do |menu|
 #    # menu.enum '                .'
 #
 #    menu.choice '                                                                                     Bitcoin'
 #    menu.choice '                                                                                     Ethereum'
 #    menu.choice '                                                                                     Litecoin'
 # end
 prompt = TTY::Prompt.new
 crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))

 puts ""
 puts "                                                                                          Here are the 2017 monthly #{crypto_chosen} price"
 puts
 puts

  prefix = "2017"

  #Crypto.where(name: crypto_chosen).where("date LIKE :prefix", prefix: "#{prefix}%").each do |coin|
  Crypto.find_by_year(crypto_chosen, prefix).each do |coin|
     #puts "#{Date::MONTHNAMES[coin.date.split("-")[1].to_i]} price is $#{coin.price}"
  coin.display
  end

# print "What's your name?".center(`tput cols`.to_i)

  puts ""
  puts "                                                                          Please answer yes or no to indicate whether or not you want to invest in a
                                                                          particular month starting from February of 2018 based on the trend of 2017"
  puts ""

  cryptos_array = Crypto.find_by_year(crypto_chosen, "2018")
  cryptos_array[0].display

  # puts "#{Date::MONTHNAMES[cryptos_array[0].date.split("-")[1].to_i]} price is $#{cryptos_array[0].price}"

  i = 1

  while i < 12
    puts
    print "                                                                                    Would you like to invest in the month of #{Date::MONTHNAMES[i + 1]}: "
    response = gets.chomp
    result = ""
    puts
    puts
    if response.downcase != "yes" && response.downcase != "no"
      puts "                                                                                          Please enter a valid response: yes or no".red
    else
      #new_investment = Investment.create(response: response, user_id: user.id, crypto_id: cryptos_array[i].id)
      if response.downcase == "yes"
        if cryptos_array[i].price < cryptos_array[i-1].price
          puts ("                                                                                   Oops! The value went down in #{Date::MONTHNAMES[i + 1]}. Price was #{cryptos_array[i].price}.").red
          result = "bad"
        else
          puts ("                                                                                   The value WENT UP!! Nice investment. Price was #{cryptos_array[i].price}.").green
          result = "good"
        end
        #Investment.create(response: response, user_id: user.id, crypto_id: cryptos_array[i].id)
        #i += 1
      elsif response.downcase == "no"
        if cryptos_array[i].price < cryptos_array[i-1].price
          puts ("                                                                             The value went down!! Good job on not investing. Price was #{cryptos_array[i].price}.").green
          result = "good"
        else
          puts ("                                                                                Too bad. You would've made some money. Price was #{cryptos_array[i].price}.").red
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
  puts "                                                                                      You've made #{reports_array.count("good")} good investments and #{reports_array.count("bad")} bad investments!"
  reports_array
end

#def previous_results(reports_array)
  #reports_array
#end
