class ArticleContent < ActiveRecord::Base


end


# == Schema Information
#
# Table name: article_contents
#
#  id         :integer         not null, primary key
#  title      :string          default(""), not null
#  desc       :text
#  tag        :string          default(""), not null
#  article_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

