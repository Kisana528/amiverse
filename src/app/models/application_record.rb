class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include AccountImages
  include CustomVariant
  def resize_image(name, name_id, type)
    attachment = case type
      when 'icon' then icon
      when 'banner' then banner
      when 'image'then image
    end
    attachment.analyze if attachment.attached?
    CustomVariant.new(attachment, image_optimize(name, name_id, type)).processed
  end
end
