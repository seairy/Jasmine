# -*- encoding : utf-8 -*-
class TaskPhotographFileUploader < BaseUploader
  version :w800_h800_ft_q80 do
    process quality: 80
    process resize_to_fit: [800, 800]
  end

  version :w600_h600_fl_q80 do
    process quality: 80
    process resize_to_fill: [600, 600]
  end

  version :w80_h80_fl_q60 do
    process quality: 60
    process resize_to_fill: [80, 80]
  end
end