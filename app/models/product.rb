class Product < ActiveRecord::Base



  mount_uploaders :idattch, AttachmentUploader

  serialize :idattch, JSON


end

# == Schema Information
#
# Table name: products
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  idattch    :string
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

