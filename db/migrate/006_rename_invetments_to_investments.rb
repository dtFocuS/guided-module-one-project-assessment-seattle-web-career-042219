class RenameInvetmentsToInvestments < ActiveRecord::Migration[5.2]
  def change
    rename_table :invetments, :investments
  end
end
