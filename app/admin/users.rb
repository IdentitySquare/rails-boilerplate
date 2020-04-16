ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column :full_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
