class RemoveProviderServiceIdFromRequests < ActiveRecord::Migration[6.1]
  def change
    remove_column :requests, :provider_service_id
  end
end
