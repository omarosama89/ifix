class CreateRequestDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :request_details do |t|
      t.integer :request_id
      t.integer :provider_service_id

      t.timestamps
    end
  end
end
