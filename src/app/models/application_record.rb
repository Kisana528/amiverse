class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include ImageTreatment
  def resize_image(type)
    attachment = image
    attachment.analyze if attachment.attached?
    attachment.variant(image_optimize(type), type).processed
  end
end
