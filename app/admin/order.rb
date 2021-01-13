ActiveAdmin.register Order do

  permit_params :category, :money, :coin, :subject

  menu label: "订单管理", :priority => 10 
  config.per_page = 20
  config.sort_order = "id_asc"

  index :title=>"充值管理" do
    selectable_column
    id_column
    column "标号", :number
    column "类别", :category
    column "金额", :money
    column "金币", :coin
    column "标题", :subject
    column "支付金额", :total_fee
    column "支付宝", :buyer_email
    column "下单时间", :sortable=>:gmt_create do |f|
      f.gmt_create.strftime('%Y-%m-%d %H:%M:%S') if f.gmt_create
    end
    column "支付时间", :sortable=>:gmt_payment do |f|
      f.gmt_payment.strftime('%Y-%m-%d %H:%M:%S') if f.gmt_payment
    end
    column "状态", :state
    column "用户" do |f|
      link_to f.user.id, admin_user_path(f.user) if f.user
    end
    column "创建时间", :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "Order详情" do
      #f.input :number, :label => "标号"
      f.input :category, :label => "类别"
      f.input :money, :label => "金额"
      f.input :coin, :label => "金币"
      f.input :subject, :label => "标题"
      #f.input :trade_no, :label => "交易号"
      #f.input :total_fee, :label => "支付金额"
      #f.input :buyer_email, :label => "支付宝"
      #f.input :gmt_create, :label => "下单时间"
      #f.input :gmt_payment, :label => "支付时间"
      #f.input :notify_msg, :label => "通知消息"
      #f.input :state, :label => "状态"
    end
    f.actions
  end

  show :id=>:id do
    attributes_table do
      row "ID" do
        order.id
      end
      row "标号" do
        order.number
      end
      row "类别" do
        order.category
      end
      row "金额" do
        order.money
      end
      row "金币" do
        order.coin
      end
      row "标题" do
        order.subject
      end
      row "交易号" do
        order.trade_no
      end
      row "支付金额" do
        order.total_fee
      end
      row "支付宝" do
        order.buyer_email
      end
      row "下单时间" do
        order.gmt_create.strftime('%Y-%m-%d %H:%M:%S') if order.gmt_create
      end
      row "支付时间" do
        order.gmt_payment.strftime('%Y-%m-%d %H:%M:%S') if order.gmt_payment
      end
      row "通知消息" do
        order.notify_msg
      end
      row "状态" do
        order.state
      end
      row "创建时间" do
        order.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        order.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
