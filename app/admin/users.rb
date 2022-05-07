ActiveAdmin.register User do
  permit_params :first_name, :last_name, :mobile_number

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :mobile_number
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :mobile_number
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :mobile_number
    end
    f.actions
  end

end
