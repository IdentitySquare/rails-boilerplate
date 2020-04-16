ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    # columns do
    #   column do
    #     panel "Total Users" do
    #       h1 class: 'big_number' do
    #         link_to ActiveSupport::NumberHelper.number_to_delimited(User.count), admin_users_path
    #       end
    #     end
    #   end
    # end


    columns do

      column do
        panel "New Users" do
          table_for User.order(created_at: :desc).limit(14).each do |user|
            column(:name)    {|user| link_to user.full_name, admin_user_path(user) }
            column(:email)    {|user| user.email.truncate(50) }
            column('created')    {|user| time_ago_in_words(user.created_at) + ' ago' }
          end
        end
      end

      # column do
      #   panel "Info" do
      #     para "Welcome to ActiveAdmin."
      #   end
      # end

    end


  end # content
end
