# == Schema Information
#
# Table name: user_files
#
#  id                      :integer          not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  folder_id               :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class UserFile < ActiveRecord::Base
  has_paper_trail
  has_attached_file :attachment, :path => ':rails_root/uploads/:rails_env/:id/:style/:id', :restricted_characters => RESTRICTED_CHARACTERS
  do_not_validate_attachment_file_type :attachment

  belongs_to :folder
  has_many :share_links, :dependent => :destroy

  validates_attachment_presence :attachment, :message => I18n.t(:blank, :scope => [:activerecord, :errors, :messages])
  validates_presence_of :folder_id
  validates_uniqueness_of :attachment_file_name, :scope => 'folder_id', :message => I18n.t(:exists_already, :scope => [:activerecord, :errors, :messages])
  validates_format_of :attachment_file_name, :with => /\A[^\/\\\?\*:|"<>]+\z/, :message => I18n.t(:invalid_characters, :scope => [:activerecord, :errors, :messages])

  searchable do
    text :attachment_file_name, :attachment
  end




  def copy(target_folder)
    new_file = self.dup
    new_file.folder = target_folder
    new_file.save!

    path = "#{Rails.root}/uploads/#{Rails.env}/#{new_file.id}/original"
    FileUtils.mkdir_p path
    FileUtils.cp_r self.attachment.path, "#{path}/#{new_file.id}"

    new_file
  end

  def move(target_folder)
    self.folder = target_folder
    save!
  end

  def extension
    File.extname(attachment_file_name)[1..-1]
  end
end
