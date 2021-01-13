class Ocr < ActiveRecord::Base

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true


end

# == Schema Information
#
# Table name: ocrs
#
#  id         :integer         not null, primary key
#  ocr_type   :integer         default("0"), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

