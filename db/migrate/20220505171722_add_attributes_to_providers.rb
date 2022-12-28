class AddAttributesToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :first_name, :string
    add_column :providers, :last_name, :string
    add_column :providers, :mobile_number, :string
    add_column :providers, :lat, :decimal, { precision: 10, scale: 6 }
    add_column :providers, :lng, :decimal, { precision: 10, scale: 6 }
    change_column_default :providers, :provider, :mobile_number
  end
end
