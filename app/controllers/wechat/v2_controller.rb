# -*- encoding : utf-8 -*-
class Wechat::V2Controller < Wechat::BaseController
  skip_before_action :authenticate
  skip_before_action :set_current_user
  skip_before_action :complete_information

  def demo
    render layout: false
  end
end