class UserPerfil < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  
  
  validates :email, uniqueness: true
  has_one :user
  has_many :inscription_in_the_establishments
  
  accepts_nested_attributes_for :user, allow_destroy: true
end
