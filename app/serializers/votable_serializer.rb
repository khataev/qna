# class for Votable serializer
class VotableSerializer < ActiveModel::Serializer
  attributes :rating

  self.root = false
end
