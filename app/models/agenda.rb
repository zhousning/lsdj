class Agenda < ActiveRecord::Base



  mount_uploader :idattch, AttachmentUploader




  belongs_to :user


end
