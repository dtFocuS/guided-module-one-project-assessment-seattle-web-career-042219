class User < ActiveRecord::Base
  has_many :investments
  has_many :cryptos, through: :investments

  

end
