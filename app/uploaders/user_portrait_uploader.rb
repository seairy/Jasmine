# -*- encoding : utf-8 -*-
class UserPortraitUploader < BaseUploader
  version :w100_h100_fl_q60 do
    process quality: 60
    process resize_to_fill: [100, 100]
  end

  version :w180_h180_fl_q60 do
    process quality: 60
    process resize_to_fill: [180, 180]
  end

  version :w500_h500_fl_q80 do
    process quality: 80
    process resize_to_fill: [500, 500]
  end
end