class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.float :price
      t.string :status
      t.integer :user_id
      t.integer :provider_service_id

      t.timestamps
    end
  end
end
