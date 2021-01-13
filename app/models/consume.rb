class Consume < ActiveRecord::Base
  belongs_to :user

  before_save :store_unique_number
  def store_unique_number
    unless self.number
      self.number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    end
  end
end

# == Schema Information
#
# Table name: consumes
#
#  id             :integer         not null, primary key
#  number         :string
#  category       :string          default("none"), not null
#  coin_cost      :float           default("0.0"), not null
#  coin_now       :float
#  status         :string          default("none"), not null
#  user_id        :integer
#  demand_id      :integer
#  trade_order_id :integer
#  citrine_id     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

