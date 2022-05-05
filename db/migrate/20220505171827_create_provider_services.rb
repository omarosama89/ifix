class CreateProviderServices < ActiveRecord::Migration[6.1]
  def change
    create_table :provider_services do |t|
      t.float :price
      t.integer :service_id
      t.integer :provider_id

      t.timestamps
    end
  end
end
