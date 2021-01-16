class Portfolio < ActiveRecord::Base






  has_many :file_libs, :dependent => :destroy
  accepts_nested_attributes_for :file_libs, reject_if: :all_blank, allow_destroy: true


  belongs_to :archive


end
