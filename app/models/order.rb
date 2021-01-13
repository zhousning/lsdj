class Order < ActiveRecord::Base
  belongs_to :user

  validates :money,      :presence => true
  validates :subject,    :presence => true

  #validates :order_id,   :presence => true

  STATE = %w(opening pending paid completed canceled)
  validates_inclusion_of :state, :in => STATE

  before_save :store_unique_number
  def store_unique_number
    unless self.number
      self.number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    end
  end

  #添加paid?和completed?等方法
  STATE.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
  end

  def pend
    if opening?
      update_attribute :state, 'pending'
    end
  end

  #只在pending状态可以pay
  def pay
    if pending?
      add_plan    #业务逻辑，订单生效
      update_attribute :state, 'paid'
    end
  end

  #只在pending和paid状态可以complete
  def complete
    if pending? or paid?
      add_plan if pending?    #如果是paid状态，已经执行过add_plan
      update_attribute :state, 'completed'
    end
  end

  #只在pending和paid状态可以cancel
  def cancel
    if pending? or paid?
      remove_plan if paid?    #业务逻辑，取消订单
      update_attribute :state, 'canceled'
    end
  end

  def pay_url
    Alipay::Service.create_direct_pay_by_user_wap_url(
      :out_trade_no      => number,
      :subject           => subject,
      :total_fee         => money,
      #:price             => price,
      #:quantity          => quantity,
      #:discount          => discount,
      #:logistics_type    => 'DIRECT',
      #:logistics_fee     => '0',
      #:logistics_payment => 'SELLER_PAY',
      :return_url        => Rails.application.routes.url_helpers.alipay_return_orders_url(:host => Setting.systems.host),
      :notify_url        => Rails.application.routes.url_helpers.alipay_notify_orders_url(:host => Setting.systems.host)
      #:receive_name      => 'none',
      #:receive_address   => 'none',
      #:receive_zip       => '100000',
      #:receive_mobile    => '100000000000'
    )
  end

  #异步处理和状态转换的逻辑已经保证了add_plan只会被执行一次
  #但不能在同步处理中再次调用，可能会出问题
  def add_plan
    self.user.account.add_coin(self.coin)
  end

  def remove_plan
  end
end

# == Schema Information
#
# Table name: orders
#
#  id          :integer         not null, primary key
#  number      :string
#  category    :string          default("none"), not null
#  money       :float
#  coin        :float
#  status      :integer         default("0"), not null
#  subject     :string
#  trade_no    :string
#  total_fee   :string
#  buyer_email :string
#  gmt_create  :datetime
#  gmt_payment :datetime
#  notify_msg  :text
#  price       :integer
#  quantity    :integer
#  state       :string          default("opening"), not null
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

