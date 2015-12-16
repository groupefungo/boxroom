# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  folder_id  :integer
#  group_id   :integer
#  can_create :boolean
#  can_read   :boolean
#  can_update :boolean
#  can_delete :boolean
#

class Permission < ActiveRecord::Base
  has_paper_trail
  belongs_to :group
  belongs_to :folder
end
