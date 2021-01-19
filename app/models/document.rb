class Document < ActiveRecord::Base
  belongs_to :examine

  validates :status, :presence => true,
                     :numericality => {:only_integer => true}

end
