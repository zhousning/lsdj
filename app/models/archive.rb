class Archive < ActiveRecord::Base






  has_many :portfolios, :dependent => :destroy
  accepts_nested_attributes_for :portfolios, reject_if: :all_blank, allow_destroy: true


  belongs_to :user


end
