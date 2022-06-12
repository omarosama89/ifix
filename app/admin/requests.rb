ActiveAdmin.register Request do
  permit_params :price, :status, :user_id, :provider_service_id

  index do
    selectable_column
    id_column
    column :price
    column :status
    column :lat
    column :lng
    column :user do |r|
      r.user.full_name
    end
    column :provider_service do |request|
      "#{request.provider_service.name} | #{request.provider_service.provider.full_name}"
    end
    column :created_at
    actions
  end

  filter :price
  filter :status
  filter :user
  filter :provider_service

  form do |f|
    f.inputs do
      f.input :price
      f.input :status,
              as: :select,
              collection: Request::STATUSES.map { |s| [s.capitalize, s]},
              include_blank: false
      f.input :user_id,
              as: :select,
              collection: User.all.map{ |u| [u.full_name, u.id] },
              include_blank: false
      f.input :provider_service_id,
              as: :select,
              collection: ProviderService.all.map{ |ps| ["#{ps.name} | #{ps.provider.full_name}", ps.id] },
              include_blank: false
      f.input :lat
      f.input :lng
    end
    f.actions
  end

end
