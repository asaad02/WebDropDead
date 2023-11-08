class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :quarters
      t.integer :dice
      t.integer :points

      t.timestamps
    end
  end
end