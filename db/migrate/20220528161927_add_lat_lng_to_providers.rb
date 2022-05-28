class AddLatLngToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :lat, :decimal, { precision: 10, scale: 6 }
    add_column :providers, :lng, :decimal, { precision: 10, scale: 6 }
  end
end
