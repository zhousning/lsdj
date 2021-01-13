ActiveAdmin.register User  do

  #permit_params  :phone, :password, :password_confirmation, :name, :identity, :alipay, :status, role_ids: []
  permit_params  :phone, :name, :identity, :alipay, :status, role_ids: []

  actions :all, :except => [:destroy]


  menu label: "用户管理", :priority => 3 
  config.per_page = 20
  config.sort_order = "id_asc"

  filter :status, :label => Setting.users.status, as: :select, collection: [[Setting.users.opening_title, Setting.users.opening], [Setting.users.pending_title, Setting.users.pending], [Setting.users.passed_title, Setting.users.passed], [Setting.users.rejected_title,Setting.users.rejected]]
  filter :phone, :label => Setting.users.phone
  filter :password, :label => Setting.users.password
  filter :password_confirmation, :label => Setting.users.password_confirmation
  filter :name, :label => Setting.users.name
  filter :identity, :label => Setting.users.identity
  filter :alipay, :label => Setting.users.alipay
  filter :created_at

  index :title=>"用户管理" do
    selectable_column
    id_column
    
    #column Setting.teams.children, :children do |f|
    #  f.children.size
    #end
    #column Setting.users.inviter, :parent do |f|
    #  f.parent.phone if f.parent
    #end
    column Setting.users.phone, :phone
    column Setting.users.name, :name
    column Setting.users.identity, :identity
    column Setting.users.alipay, :alipay
    #column Setting.users.status, :status do |f|
    #  f.state
    #end

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions do
      #link_to "分配角色", admin_assign_path
    end
  end

  form do |f|
    f.inputs "详情" do
      f.input :phone, :label => Setting.users.phone 
      #f.input :password, :label => Setting.users.password 
      #f.input :password_confirmation, :value => "3423", :label => Setting.users.password_confirmation 
      f.input :name, :label => Setting.users.name 
      f.input :identity, :label => Setting.users.identity 
      f.input :alipay, :label => Setting.users.alipay 
      f.input :roles, :label => "角色分配", as: :check_boxes 
    end
    f.actions
  end

  show :title=>'用户管理' do
    attributes_table do
      row "ID" do
        user.id
      end
      row Setting.users.phone do
        user.phone
      end
      #row Setting.users.password do
      #  user.password
      #end
      #row Setting.users.password_confirmation do
      #  user.password_confirmation
      #end
      row Setting.users.name do
        user.name
      end
      row Setting.users.identity do
        user.identity
      end
      row Setting.users.alipay do
        user.alipay
      end
      #row Setting.users.status do
      #  user.state
      #end

      row "角色" do
        table_for user.roles do
          column "角色详情",  :name
        end
      end

      row "创建时间" do
        user.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        user.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      #row "审核" do
      #  link_to(Setting.users.passed_title, pass_admin_user_path(user.id)) + "  " +
      #  link_to(Setting.users.rejected_title, reject_admin_user_path(user.id))
      #end
    end
  end

  member_action :pass do
    user = User.find(params[:id])
    user.pass
    user.tree.add_count(1) if user.tree.count == 0 
    user.leaf.enable
    user.account.enable
    father = user.parent
    if father
      father.citrine.add_count(Setting.awards.ten_citrine)
      Consume.create(:category => Setting.consumes.category_friend_authc, :coin_cost => Setting.awards.ten_citrine, :status => Setting.consumes.status_success, :citrine_id => father.citrine.id)
      if grandpa = father.parent
        grandpa.citrine.add_count(Setting.awards.one_citrine) 
        Consume.create(:category => Setting.consumes.category_friend_authc, :coin_cost => Setting.awards.one_citrine, :status => Setting.consumes.status_success, :citrine_id => grandpa.citrine.id)
      end
    end
    redirect_to admin_user_path(params[:id])
  end

  member_action :reject do
    user = User.find(params[:id])
    user.reject
    user.leaf.disable
    user.account.disable
    redirect_to admin_user_path(params[:id])
  end

end

