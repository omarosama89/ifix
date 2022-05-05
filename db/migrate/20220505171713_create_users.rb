class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :mobile_number
      t.boolean :verified
      t.string :token
      t.string :reset_token
      t.datetime :last_login
      t.string :current_ip

      t.timestamps
    end
  end
end
