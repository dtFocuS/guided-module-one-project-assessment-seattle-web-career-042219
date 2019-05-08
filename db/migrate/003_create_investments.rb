class CreateInvestments < ActiveRecord::Migration[5.2]
  def change
    create_table :invetments do |t|
      t.integer :user_id
      t.integer :crypto_id
      t.string :response
    end
  end
end
