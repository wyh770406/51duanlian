class GymImage < ActiveRecord::Base
  belongs_to :gym
  acts_as_list scope: :gym

  mount_uploader :image, ImageUploader
end
