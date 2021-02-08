class Agenda < ActiveRecord::Base



  mount_uploader :idattch, AttachmentUploader




  belongs_to :user


end

# == Schema Information
#
# Table name: agendas
#
#  id         :integer         not null, primary key
#  title      :string          default(""), not null
#  content    :text
#  worktime   :datetime
#  idattch    :string          default(""), not null
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

