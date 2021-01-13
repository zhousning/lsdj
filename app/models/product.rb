class Product < ActiveRecord::Base



  mount_uploaders :idattch, AttachmentUploader

  serialize :idattch, JSON


end
