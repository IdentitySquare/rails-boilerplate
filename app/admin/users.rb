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

  member_action :impersonate, method: :post do
    if user_signed_in?
      impersonate_user(resource)
      redirect_to root_path, notice: "Logged in as #{resource.full_name}!"
    else
      redirect_to admin_user_path(resource), notice: "You need to be logged in as a normal user first before trying to impersonate someone else."
    end
  end

  action_item :impersonate, only: :show  do
    link_to "Impersonate", impersonate_admin_user_path(resource), method: :post, data: {confirm: 'Are you sure you would like to act as this user?'}
  end

  collection_action :stop_impersonating, method: :post do
    stop_impersonating_user
    redirect_to collection_path, notice: "Back to yourself!"
  end

end
