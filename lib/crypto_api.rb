require_relative '../app/models/crypto'
require_relative '../app/models/investment'
require_relative '../app/models/user'



puts "Welcome"
print "Please enter your name: "
name_response = gets.chomp
current_user = nil
if !User.find_by(name: name_response)
  current_user = User.create(name: name_response)
else
  current_user = User.find_by(name: name_response)
end
prompt = TTY::Prompt.new
crypto_chosen = prompt.select("Choose your crypto:", %w(Bitcoin Ethereum Litecoin))
puts ""
puts "Here are the 2017 monthly #{crypto_chosen} price"


prefix = "2017"
# Crypto.where(name: crypto_chosen).where("date LIKE :prefix", prefix: "#{prefix}%").each do |coin|
Crypto.find_by_year(crypto_chosen, prefix).each do |coin|
  # puts "#{Date::MONTHNAMES[coin.date.split("-")[1].to_i]} price is $#{coin.price}"
  coin.display
end
puts ""
puts "Please answer yes or no to indicate whether or not you want to invest in a
particular month starting from February of 2018 based on the trend of 2017"
puts ""

results_array = Crypto.find_by_year(crypto_chosen, "2018")

results_array[0].display
#puts "#{Date::MONTHNAMES[results_array[0].date.split("-")[1].to_i]} price is $#{results_array[0].price}"
i = 1
reports_array = []
while i < 12
  print "Would you like to invest in the month of #{Date::MONTHNAMES[i + 1]}: "
  response = gets.chomp
  if response.downcase != "yes" && response.downcase != "no"
    puts "Please enter a valid response."
  else
  #new_investment = Investment.create(response: response, user_id: current_user.id, crypto_id: results_array[i].id)
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
  puts ""
end
#Investment.destroy_all
puts "You've made #{reports_array.count(true)} good investments and #{reports_array.count(false)} bad investments!"
