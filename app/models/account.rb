class Account < ActiveRecord::Base
  belongs_to :user

  validates :coin,        :numericality => {:greater_than_or_equal_to => 0}, :on => :update
  validates :freeze_coin, :numericality => {:greater_than_or_equal_to => 0}, :on => :update

  #validates :password, :presence => true

  before_save :store_unique_number
  def store_unique_number
    unless self.number
      self.number = "0xx" + (SecureRandom.hex 16)
    end
  end

  def add_coin(value)
    self.update_attribute :coin, (self.coin + value)
  end

  def sub_coin(value)
    self.update_attribute :coin, (self.coin - value)
  end

  def add_freeze_coin(value)
    self.update_attribute :freeze_coin, (self.freeze_coin + value)
  end

  def sub_freeze_coin(value)
    self.update_attribute :freeze_coin, (self.freeze_coin - value)
  end

  def add_commision(value)
    self.update_attribute :commission, (self.commission + value)
    self.update_attribute :coin, (self.coin + value)
  end

  def sub_commision(value)
    self.update_attribute :commission, (self.commission - value)
    self.update_attribute :coin, (self.coin - value)
  end

  def add_password(value)
    self.update_attribute :password, Digest::MD5.hexdigest(value) unless value.blank?
  end

  def enable
    update_attribute :status, Setting.accounts.enable 
  end

  def disable
    update_attribute :status, Setting.accounts.disable 
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id          :integer         not null, primary key
#  coin        :float           default("0.0"), not null
#  freeze_coin :float           default("0.0"), not null
#  commission  :float           default("0.0"), not null
#  status      :string          default("disable"), not null
#  password    :string          default(""), not null
#  number      :string
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

