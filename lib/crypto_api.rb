require_relative '../app/models/crypto'

puts "Welcome"
puts "Bitcoin"
print "Please enter your name: "
name_response = gets.chomp
#current_user = User.create(name: name_response)

prompt = TTY::Prompt.new
crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))

puts "Here are the 2017 monthly #{crypto_chosen} price"


prefix = "2017"
Crypto.where(name: crypto_chosen).where("date LIKE :prefix", prefix: "#{prefix}%").each do |coin|
  puts "#{Date::MONTHNAMES[coin.date.split("-")[1].to_i]} price is $#{coin.price}"
end
puts ""
puts "Please answer yes or no to indicate whether or not you want to invest in a
particular month starting from February of 2018 based on the trend of 2017"

results_array = Crypto.where(name: crypto_chosen ).where("date LIKE :prefix", prefix: "2018%")

puts "#{Date::MONTHNAMES[results_array[0].date.split("-")[1].to_i]} price is $#{results_array[0].price}"
i = 2
reports_array = []
while i < 13
  print "Would you like to invest in the month of #{Date::MONTHNAMES[i]}: "
  response = gets.chomp
  #new_investment = Investment.create(response: response, user_id: current_user.id, crypto_id: results_array[i].id)
  if response.downcase == "yes"
    if results_array[i-1].price < results_array[i-2].price
      puts "Oops! The value went down in #{Date::MONTHNAMES[i]}. Price was #{results_array[i-1].price}."
      reports_array << false
    else
      puts "The value WENT UP!! Nice investment. Price was #{results_array[i-1].price}."
      reports_array << true
    end
    i += 1
  elsif response.downcase == "no"
    if results_array[i-1].price < results_array[i-2].price
      puts "The value WENT DOWN!! Price was #{results_array[i-1].price}."
      reports_array << true
    else
      puts "Too bad. You woulda made some money. Price was #{results_array[i-1].price}."
      reports_array << false
    end
    i += 1
  else
    puts "Please enter a valid response."
  end
  puts ""
end

puts "You've made #{reports_array.count(true)} good investments and #{reports_array.count(false)} bad investments!"