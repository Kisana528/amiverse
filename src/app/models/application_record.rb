class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include ImageTreatment
  def treat_image(attachment, type)
    attachment = self.send(attachment.to_s)
    attachment.analyze if attachment.attached?
    attachment.variant(image_optimize(type), type).processed
  end
  def delete_treated_image(attachment, type)
  end
  private
  def add_mca_data(object, column, add_mca_array)
    mca_array = JSON.parse(object[column.to_sym])
    add_mca_array.each do |role|
      mca_array.push(role)
    end
    object.update(column.to_sym => mca_array.to_json)
  end
  def remove_mca_data(object, column, remove_mca_array)
    mca_array = JSON.parse(object[column.to_sym])
    remove_mca_array.each do |role|
      mca_array.delete(role)
    end
    object.update(column.to_sym => mca_array.to_json)
  end
end
