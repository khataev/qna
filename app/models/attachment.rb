# Model for Attachment
class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FileUploader
end
