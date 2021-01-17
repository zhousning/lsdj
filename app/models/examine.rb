class Examine < ActiveRecord::Base






  belongs_to :user


  has_many :exm_items, :dependent => :destroy
  accepts_nested_attributes_for :exm_items, reject_if: :all_blank, allow_destroy: true


end
