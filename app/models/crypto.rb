class Crypto < ActiveRecord::Base
  has_many :investments

  def self.find_by_year(crypto, year)
    where(name: crypto).where("date LIKE :prefix", prefix: "#{year}%")
  end

  def display
    puts "                                                                                                  #{Date::MONTHNAMES[self.date.split("-")[1].to_i]} price is $#{self.price}"
  end
end
