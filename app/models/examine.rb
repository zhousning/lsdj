class Examine < ActiveRecord::Base

  belongs_to :user


  has_many :exm_items, :dependent => :destroy
  accepts_nested_attributes_for :exm_items, reject_if: :all_blank, allow_destroy: true

  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

end

# == Schema Information
#
# Table name: examines
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  hierarchy  :text
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

