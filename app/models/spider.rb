class Spider < ActiveRecord::Base
  #serialize :header, Hash

  has_many :selectors, :dependent => :destroy
  accepts_nested_attributes_for :selectors, reject_if: :all_blank, allow_destroy: true


end



# == Schema Information
#
# Table name: spiders
#
#  id           :integer         not null, primary key
#  link         :string          default(""), not null
#  doc_save     :boolean         default("t"), not null
#  doc_parse    :boolean         default("t"), not null
#  header       :text
#  cookie       :string          default(""), not null
#  agent        :string          default(""), not null
#  content_type :string          default(""), not null
#  page         :string          default(""), not null
#  file         :string          default(""), not null
#  referer      :string          default(""), not null
#  host         :string          default(""), not null
#  redirection  :string          default(""), not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

