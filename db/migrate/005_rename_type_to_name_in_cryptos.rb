class RenameTypeToNameInCryptos < ActiveRecord::Migration[5.2]
  def change
    rename_column :cryptos, :type, :name
  end
end
