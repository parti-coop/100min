class Image < ApplicationRecord
  mount_uploader :file, DefaultImageUploader
end
