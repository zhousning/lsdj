class Statistic < ActiveRecord::Base






  belongs_to :user


end

# == Schema Information
#
# Table name: statistics
#
#  id         :integer         not null, primary key
#  title      :string          default(""), not null
#  xtitle     :string          default(""), not null
#  ytitle     :string          default(""), not null
#  legend     :string          default(""), not null
#  data       :text
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

