class Article < ActiveRecord::Base

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true


  has_many :article_contents, :dependent => :destroy
  accepts_nested_attributes_for :article_contents, reject_if: :all_blank, allow_destroy: true


end


# == Schema Information
#
# Table name: articles
#
#  id         :integer         not null, primary key
#  lang       :string          default(""), not null
#  title      :string          default(""), not null
#  vol        :string          default(""), not null
#  desc       :string          default(""), not null
#  category   :text
#  address    :string          default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

