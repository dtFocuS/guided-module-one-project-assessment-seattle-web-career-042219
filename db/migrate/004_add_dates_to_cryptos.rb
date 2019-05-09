class AddDatesToCryptos < ActiveRecord::Migration[5.2]
  def change
    add_column :cryptos, :date, :string
  end
end
