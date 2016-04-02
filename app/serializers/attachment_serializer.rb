# class for Attachment serializer
class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :url

  def url
    object.file.url
  end
end
