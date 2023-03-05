module CustomVariant
  class CustomVariant < ActiveStorage::Variant
    def key
      "variants/#{blob.key}.webp"
    end
  end
end
