ActiveAdmin.register ProviderService do
  permit_params :price, :provider_id, :service_id

  index do
    selectable_column
    id_column
    column :price
    column :provider do |provider_service|
      provider_service.provider.full_name
    end
    column :service do |provider_service|
      provider_service.service.name
    end
    column :created_at
    actions
  end

  filter :name
  filter :provider
  filter :service
  filter :created_at

  form do |f|
    f.inputs do
      f.input :price
      f.input :provider_id,
              as: :select,
              collection: Provider.all.map{ |p| [p.full_name, p.id] },
              include_blank: false
      f.input :service_id,
              as: :select,
              collection: Service.all.map{ |p| [p.name, p.id] },
              include_blank: false
    end
    f.actions
  end

end
