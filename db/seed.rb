def populate_crypto
  year_array = ["2017", "2018"]
  bitcoin_array = ["Bitcoin", "Ethereum", "Litecoin"]
  price_hash = {}

  year_array.each do |year|
    bitcoin_array.each do |type|
      price_hash[type] = [] if !price_hash.key?(type)
      month = 1
      while month < 13
        temp = ""
        if month < 10
          temp = "0" + "#{month}"
        else
          temp = "#{month}"
        end
        response = RestClient.get("https://api.coingecko.com/api/v3/coins/#{type.downcase}/history?date=01-#{temp}-#{year}")
        response_hash = JSON.parse(response)
        price = response_hash["market_data"]["current_price"]["usd"].round(2)
        price_hash[type] << {"#{year}-#{month}" => price}
        month += 1
      end
    end
    #i += 1
  end
  price_hash.each do |coin, info|
    info.each do |hash|
      hash.each do |key, value|
        target = Crypto.create(name: coin, price: value, date: key)
      end
    end
  end
end
