class AddLatLngToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :lat, :decimal, { precision: 10, scale: 6 }
    add_column :requests, :lng, :decimal, { precision: 10, scale: 6 }
  end
end
