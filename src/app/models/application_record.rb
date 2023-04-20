class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include AccountImages
  def resize_image(name, name_id, type)
    attachment = image
    attachment.analyze if attachment.attached?
    attachment.variant(image_optimize(name, name_id, type), type).processed
  end
end
