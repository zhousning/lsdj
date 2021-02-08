class Portfolio < ActiveRecord::Base






  has_many :file_libs, :dependent => :destroy
  accepts_nested_attributes_for :file_libs, reject_if: :all_blank, allow_destroy: true


  belongs_to :archive


end

# == Schema Information
#
# Table name: portfolios
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  archive_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

