ActiveAdmin.register Service do
  permit_params :name, :icon

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form :html => { multipart: true } do |f|
    f.inputs do
      f.input :name
      f.input :icon, as: :file
    end
    f.actions
  end

end
