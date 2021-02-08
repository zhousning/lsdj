class ExmItem < ActiveRecord::Base






  belongs_to :examine


end

# == Schema Information
#
# Table name: exm_items
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  hierarchy  :text
#  examine_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

