class FileLib < ActiveRecord::Base






  belongs_to :portfolio


end

# == Schema Information
#
# Table name: file_libs
#
#  id           :integer         not null, primary key
#  name         :string          default(""), not null
#  path         :string          default(""), not null
#  file_type    :string          default(""), not null
#  portfolio_id :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

