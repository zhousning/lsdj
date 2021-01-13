# coding: utf-8

class OrdersController < ApplicationController
  layout "application_mobile"
  before_filter :authenticate_user!, :except=>[:alipay_notify]
  #protect_from_forgery :only=>[:alipay_notify]
  skip_before_filter :verify_authenticity_token, :only => [:alipay_notify]

  def new
    @order = Order.new
  end

  def create
    #Todo: 只要点击按钮就会创建订单，需要添加限制条件
    @order = Order.new(order_params)

    if @order.money and @order.money >= 0.01
      @order.category = Setting.orders.category_recharge
      @order.coin = @order.money;

      @order.subject = "茶源账户充值"
      @order.user = current_user

      if @order.save
        redirect_to @order.pay_url
      else
        render :new
      end
    else
      render :new
    end
  end

  def pay
    @order = Order.find_by_number(params[:id])
    redirect_to @order.pay_url
  end

  def alipay_return
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params)
      #同步处理会在5秒钟后自动跳转，假设异步消息比同步要快
      #这里只提示不修改状态，否则可能会出现重复处理!!!
      #@order = Order.find_by_number(params[:out_trade_no])
      #redirect_to order_url(:id=>@order.number)
      redirect_to info_accounts_url 

      #if @order.paid? || @order.completed?
      #  flash.now[:success] = I18n.t('order_paid_message')
      #elsif @order.pending?
      #  flash.now[:info] = I18n.t('order_pending_message')
      #end
    else
      redirect_to new_order_url
    end
  end

  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Sign.verify?(notify_params) and Alipay::Notify.verify?(notify_params)
      @order = Order.find_by_number(params[:out_trade_no])

      case params[:trade_status]
      #when 'WAIT_BUYER_PAY'  #Alipay不触发这个消息的通知
      #  @order.update_attribute :trade_no, params[:trade_no]
      #  @order.pend
      when 'TRADE_SUCCESS'
        @order.update_attributes(:trade_no=>params[:trade_no], :total_fee=>params[:total_fee], :buyer_email=>params[:buyer_email], :gmt_create=>params[:gmt_create], :gmt_payment=>params[:gmt_payment], :notify_msg=>params.to_s)
        #Todo: 判断total_fee是否确实为该订单的实际金额
        @order.pend
        @order.complete
      when 'TRADE_FINISHED'
        @order.update_attributes(:trade_no=>params[:trade_no], :buyer_email=>params[:buyer_email], :gmt_create=>params[:gmt_create], :gmt_payment=>params[:gmt_payment], :notify_msg=>params.to_s)
        @order.pend
        @order.complete
      #when 'TRADE_CLOSED'  #Alipay不触发这个消息的通知
      #  @order.cancel
      end

      render :text => 'success'
    else
      render :text => 'error'
    end
  end

  private
    def order_params
      params.require(:order).permit(:money)
    end
end
