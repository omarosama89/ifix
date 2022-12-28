class AddAttributesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :mobile_number, :string
    change_column_default :users, :provider, :mobile_number
  end
end
