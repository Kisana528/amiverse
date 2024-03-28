class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  private
  def validate_using_image(ins, image_aid, account_id = 0)
    Rails.logger.info('======きました======')
    if image_aid.present?
      Rails.logger.info('======あります======')
      if image = Image.where('BINARY aid = ?', image_aid).first
        Rails.logger.info('======画像は存在======')
        unless account_id == image.account_id
          Rails.logger.info('======違う人の画像======')
          if image.private || JSON.parse(image.permission_scope).all? { |item| item.is_a?(Hash) && !item['icon'].nil? }   
            ins.errors.add(:base, '画像の所有者はアイコンに設定することを許可していません')
          end
        end
      else
        ins.errors.add(:base, '存在しない画像をアイコンに設定しようとしています')
      end
    end
  end
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
