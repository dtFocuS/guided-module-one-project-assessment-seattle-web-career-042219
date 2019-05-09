class AddResultsToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :result, :string
  end
end
